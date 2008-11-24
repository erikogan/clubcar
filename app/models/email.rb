class Email < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :address
  validates_uniqueness_of :address
end
