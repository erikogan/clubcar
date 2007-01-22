class User < ActiveRecord::Base
  has_many :moods
  # I don't think this relationship is actually meaningful 
  # has_many :preferences, :through => :moods
end
