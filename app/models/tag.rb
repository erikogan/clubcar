class Tag < ActiveRecord::Base
  has_many :labels
  has_many :restaurants, :through => :labels
  belongs_to :tag_type
end
