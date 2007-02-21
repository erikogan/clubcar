class Tag < ActiveRecord::Base
  has_many :labels
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
end

#class Genre < Tag
#end
