class Tag < ActiveRecord::Base
  has_many :labels
  has_many :restaurants, :through => :labels
end
