class Preference < ActiveRecord::Base
  belongs_to :mood
  belongs_to :restaurant
  #has_one :user, :through => :mood

  # need to define the constants first
  # validates_inclusion_of :value, :in => VALID_VALUES

  POSITIVE = 5
  NEUTRAL = 0
  NEGATIVE = -5
  VETO = -100

  DEFAULT = NEUTRAL

private

  # stay DRY. Add values here, and the other constants are based on this.
  ORDERED_VALUES = [
    [:positive, POSITIVE],
    [:neutral, NEUTRAL],
    [:negative, NEGATIVE],
    [:veto, VETO]
  ]

  VALUES = Hash[*[ORDERED_VALUES, ORDERED_VALUES.flatten.reverse].flatten]
  VALUES[:default] = DEFAULT

  VALUE_ORDER = ORDERED_VALUES.collect {|v| v[0]}

  # VALID_VALUES = Hash[*[ORDERED_VALUES.collect{|v| [v[1],1]}].flatten]
  VALID_VALUES = ORDERED_VALUES.collect {|v| v[1]}
public

  validates_inclusion_of :value, :in => VALID_VALUES

  def self.values
    VALUES.clone
  end

  def self.value(key)
    unless VALUES.has_key?(key) 
      raise "No value for \"#{key}\""
    end

    if key.instance_of?(Symbol)
      VALUES[key]
    else
      VALUES[key].to_s.humanize
    end
  end

  def self.value_order
    VALUE_ORDER.clone
  end

  def self.missing_for(mood)
    i = 0
    Restaurant.find(:all, :order => :name, :conditions => ["id NOT IN (?)", 
		      mood.restaurants.collect do |r| 
			r.id
		      end
		    ]).collect do |r|

      # since we've already done the fetches, there's no point in redoing
      # them later.
      p = Preference.new(:mood_id => mood.id, # :restaurant_id => r.id, 
		     :value => DEFAULT )
      p.mood = mood
      p.restaurant = r

      # I was going to do this with a facade/delegator class, but I'm
      # not used to Ruby's open classes (as well as instance classes).
      # I'm not really sure this bit of cleverness is a good idea, either.
      class << p
	attr_accessor :id_before_type_cast
      end
      p.id_before_type_cast = i
      i+=1
      p
    end
  end
end
