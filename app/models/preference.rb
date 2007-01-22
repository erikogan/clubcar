class Preference < ActiveRecord::Base
  has_one :mood
  # has_one :user, :through => :mood
end
