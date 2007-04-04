class Mood < ActiveRecord::Base
  belongs_to :user
  has_many :preferences, :dependent => :destroy
  has_many :restaurants, :through => :preferences

  attr_protected :active
end
