class Restaurant < ActiveRecord::Base
  has_many :labels, :dependent => :destroy
  has_many :tags,   :through => :labels, :conditions => Tag.tag_conditions
  has_many :genres, :through => :labels, :conditions => Tag.genre_conditions,
    :source => :tag

  def tags_string()
    tags.collect {|t| t.name}.join(", ")
  end

  def tags_string=(*args) 
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
    (add, del) = self.tag_delta(Tag.genre_type, self.genres, *args)
    
    # grn, zeroing foreign keys breaks NOT NULL
    self.remove_labels_for_tags(del)
    # Now this is safe, because the label rows have been removed
    self.genres.delete(del)
    self.genres << add

    self.save
    self
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

