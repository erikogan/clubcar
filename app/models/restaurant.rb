class Restaurant < ActiveRecord::Base
  has_many :labels
  has_many :tags, :through => :labels
end
