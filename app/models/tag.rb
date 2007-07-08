class Tag < ActiveRecord::Base
  has_many :labels, :dependent => :destroy
  has_many :restaurants, :through => :labels
  belongs_to :tag_type, :foreign_key => :type_id

  @@tag_type   = TagType.find_by_name("Tag")
  @@genre_type = TagType.find_by_name("Genre")

  validates_presence_of(:canonical)
  validates_presence_of(:name)

  # And, by extension, :name
  validates_uniqueness_of(:canonical)

  def validate 
    if (self.canonical != Tag.canonicalize(self.name))
      errors.add(:name, "Must simplify to the canonical name")
      return false
    end
    true
  end

  def self.canonicalize(name)
    name.downcase.gsub(/\W+/,'')
  end

  # Right now, tags are unique by canonical name, if that changes, we'll
  # need to include types
  def self.find_by_name(name, *args)
    self.find_by_canonical(canonicalize(name), *args)
  end

  # This is a perfect case for Single Table Inheritance, but I can't
  # bring myself to de-normalize the data. (Even though the joins are
  # almost certainly more overhead than I can justify)

  def self.tag_type
    @@tag_type
  end

  def self.genre_type
    @@genre_type
  end

  def self.tag_conditions
    [ 'tags.type_id = ?', @@tag_type.id ]
  end

  def self.genre_conditions
    [ 'tags.type_id = ?', @@genre_type.id ]
  end

  def name=(name)
    canon = Tag.canonicalize(name)
    if (self.canonical.blank?) 
      super(name)
      self.canonical = canon
    else
      if (self.canonical != canon)
	raise "Name (#{name}) must reduce to canonical name: #{self.canonical} (not \"#{canon})"
      end
      super(name)
    end
  end

  # All that really matters is the canonical name and type
  def ==(other)
#     puts "IO: " + other.instance_of?(Tag).to_s
#     puts "TI: " + (self.type_id == other.type_id).to_s
#     puts "CA: " + (self.canonical == other.canonical).to_s
    
#     puts "CALLED == (2)\n"
    other.instance_of?(Tag) && (self.type_id == other.type_id) && (self.canonical == other.canonical)
  end

  def eql?(other)
    # puts "CALLED eql?\n"
    self == other
  end

  def ===(other)
    # puts "CALLED === (3)\n"
    self == other
  end

  # Since I override eql? I should also override this. (Though the
  # reverse is more true)
  def hash 
    # puts "CALLED hash()\n"
    [self.canonical, self.type_id].hash
  end

#  def equal?(other)
#    puts "CALLED equal?\n"
#    super
#  end
  
  def self.fetch(type, *args)
    tags = Array.new
    for arg in args.flatten
      if arg.instance_of?(Tag)
	tags.push(arg)
      else
	for tag in arg.to_s.split(/,\s*/)
	  canon = canonicalize(tag)
	  # find_or_create_by_name doesn't call find_by_name... (l@m3)
	  t = find_by_canonical_and_type_id(canon, type.id)
	  if (t.nil?)
	    # Remember, setting :name also sets :canonical
	    t = new(:name => tag, :tag_type => type)
	    t.save
	  end
	  tags.push(t)
	end
      end
    end
    return tags
  end

  def self.find_unscored_genres
    # I need to figure out how to NOT include all the columns in the GROUP BY
    tCols = Tag.columns.reject { |c| c.name == 'canonical' }.map {|c| "t.#{c.name}"}

    return Tag.find_by_sql(<<endSQL)
SELECT	t.*, 1 AS weight
FROM 	restaurants AS r
LEFT JOIN restaurants_date_distance AS rdd
	ON rdd.restaurant_id = r.id
	labels AS l,
	tag_types AS tt,
	tags AS t
WHERE	t.type_id = #{@@genre_type.id}
	AND l.tag_id = t.id
	AND l.restaurant_id = r.id
-- I hate to add this as a special case, but I need to rework the
-- selection algorithm, and the brought in restaurants nobody wants to
-- go to are killing the genres
	AND r.id NOT IN (SELECT	subL.restaurant_id 
			 FROM	labels AS subL, 
				tags subT 
			 WHERE	canonical = 'broughtin' 
				AND subL.tag_id = subT.id)
GROUP BY t.canonical, #{tCols.join(', ')}
HAVING 	(MIN(date_distance) > 3 OR MIN(date_distance) IS NULL)
ORDER BY t.name
endSQL

  end

  def self.find_scored_genres(not_in=[-1])
    # I need to figure out how to NOT include all the columns in the GROUP BY
    tCols = Tag.columns.reject { |c| c.name == 'canonical' }.map {|c| "t.#{c.name}"}
    # unfortunately, I can't use parameters
    # return Tag.find_by_sql(<<endSQL, @@genre_type.id, not_in)
    not_in = not_in.join ', '

    return Tag.find_by_sql(<<endSQL)
SELECT	t.*,
	MIN(date_distance) AS distance,
	SUM(genre_total) AS score,
	SUM(genre_total) / count(r.*) AS score_per_restaurant,
-- The linear weighting was too much, make it logarithmic (and move it
-- into the SQL). Everybody gets one point for showing up, thus the 2+score.
	ROUND(#{Restaurant::VOTE_TO_DATE_DISTANCE_RATIO} 
	      * LOG(2, 2+(SUM(genre_total) / COUNT(r.*))) 
	      + LOG(2, 
		    CASE WHEN MIN(date_distance) IS NULL 
		    THEN #{Restaurant::DATE_DISTANCE_MAX} 
		    WHEN MIN(date_distance) > #{Restaurant::DATE_DISTANCE_MAX} 
		    THEN #{Restaurant::DATE_DISTANCE_MAX} 
		    ELSE MIN(date_distance)
		    END
		    )) AS weight
FROM 	restaurants AS r
LEFT JOIN restaurants_date_distance AS rdd
	ON rdd.restaurant_id = r.id
LEFT JOIN active_vote_totals AS avt
	ON avt.restaurant_id = r.id,
	labels AS l,
	tag_types AS tt,
	tags AS t
WHERE	t.type_id = #{@@genre_type.id}
	AND t.id NOT IN (#{not_in})
	AND l.tag_id = t.id
	AND l.restaurant_id = r.id
-- I hate to add this as a special case, but I need to rework the
-- selection algorithm, and the brought in restaurants nobody wants to
-- go to are killing the genres
	AND r.id NOT IN (SELECT	subL.restaurant_id 
			 FROM	labels AS subL, 
				tags subT 
			 WHERE	canonical = 'broughtin' 
				AND subL.tag_id = subT.id)
-- GROUP BY t.*
GROUP BY t.canonical, #{tCols.join(', ')}
HAVING 	(MIN(date_distance) > 3 OR MIN(date_distance) IS NULL)
	AND SUM(genre_total) >= 0
ORDER BY t.name
endSQL
  end

end

#class Genre < Tag
#end
