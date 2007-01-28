class Mood < ActiveRecord::Base
  belongs_to :user
  has_many :preferences
  has_many :restaurants, :through => :preferences
end
