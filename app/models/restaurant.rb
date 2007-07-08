class Restaurant < ActiveRecord::Base
  has_many :labels, :dependent => :destroy
  has_many :tags,   :through => :labels, :conditions => Tag.tag_conditions
  has_many :genres, :through => :labels, :conditions => Tag.genre_conditions,
    :source => :tag
  has_many :visits

  # This should be configurable (note, setting this value to < 0.5 could
  # cause collisions in the algorithm below)
  VOTE_TO_DATE_DISTANCE_RATIO = 4.0
  
  # This, too, should be configurable
  DATE_DISTANCE_MAX = 14 # (after two weeks, does it really matter?)

  def tags_string()
    tags.collect {|t| t.name}.join(", ")
  end

  def tags_string=(*args) 
    # has_many :through needs real records
    self.save if @new_record

    (add, del) = self.tag_delta(Tag.tag_type, self.tags, *args)

    # grn, zeroing foreign keys breaks NOT NULL
    self.remove_labels_for_tags(del)
    # Now this is safe, because the label rows have been removed
    self.tags.delete(del)
    self.tags << add

    self.save
    self
  end

  def genres_string()
    genres.collect {|t| t.name}.join(", ")
  end

  def genres_string=(*args) 
    # has_many :through needs real records
    self.save if @new_record

    (add, del) = self.tag_delta(Tag.genre_type, self.genres, *args)
    
    # grn, zeroing foreign keys breaks NOT NULL
    self.remove_labels_for_tags(del)
    # Now this is safe, because the label rows have been removed
    self.genres.delete(del)
    self.genres << add

    self.save
    self
  end

  def self.find_all_by_tag_with_active_scores(tag)
    find_by_sql(<<EndSQL)
SELECT 	r.*, avt.total
FROM	labels AS l,
	restaurants AS r
LEFT JOIN active_vote_totals AS avt
	ON avt.restaurant_id = r.id
WHERE 	l.tag_id = #{tag.id}
	AND l.restaurant_id = r.id
	AND (avt.total >= 0 OR avt.total IS NULL);
EndSQL
  end

  protected

  # ARGH! self.{tags,labels}.delete(...) violates the NOT NULL
  # constraint on labels.restaurant_id. Do it by hand.
  def remove_labels_for_tags(type, *args)
    tags = Tag.fetch(type, args)
    ids = tags.inject(Hash.new) { |h,t| h[t.id] = t ; h }
    
    del = self.labels.inject(Array.new) do |a,l|
      if (ids.include?(l.tag_id))
	a << l
      end
      a
    end
    Label.delete(del)
    self.labels.delete(del)
  end

  def tag_delta(type, current, *args)
    old = Set.new(current)
    new = Set.new(Tag.fetch(type, *args))
    
    xor = old ^ new

    # Set intersection favors the right side, union the left. I'm sure
    # there's a reason for that.
    del = (xor & old).to_a
    add = (xor & new).to_a

    return add,del
  end

end

