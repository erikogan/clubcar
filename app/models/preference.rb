class Preference < ActiveRecord::Base
  belongs_to :mood
  belongs_to :restaurant
  #has_one :user, :through => :mood

  POSITIVE = 5
  NEUTRAL = 0
  NEGATIVE = -5
  VETO = -100
end
