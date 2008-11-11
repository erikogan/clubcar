class Preference < ActiveRecord::Base
  belongs_to :mood
  belongs_to :restaurant
  belongs_to :vote
  #has_one :user, :through => :mood

  # kept for historical reasons (db migrations need it)
  NEUTRAL = 0
  DEFAULT = NEUTRAL

  def self.missing_for(mood)
    i = 0
    defVote = Vote.default
    rIDs = mood.restaurants.collect { |r| r.id }
    # I forgot about the empty case
    rIDs = [-1] if rIDs.empty?

    Restaurant.find(:all, :order => :name, 
                    :conditions => ["id NOT IN (?)", rIDs]).collect do |r|

      # since we've already done the fetches, there's no point in redoing
      # them later.
      p = Preference.new(:mood_id => mood.id, # :restaurant_id => r.id, 
                         :vote_id => defVote.id )
      p.mood = mood
      p.restaurant = r

      # I was going to do this with a facade/delegator class, but I'm
      # not used to Ruby's open classes (as well as instance classes).
      # I'm not really sure this bit of cleverness is a good idea, either.
      # (Rails uses this method in the field names (foo[id]))
      class << p
        attr_accessor :id_before_type_cast
      end
      p.id_before_type_cast = i
      i+=1
      p
    end
  end
end
