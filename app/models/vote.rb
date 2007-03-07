class Vote < ActiveRecord::Base
  has_many :preferences

  def self.default
    self.find_by_name('Neutral')
  end
end
