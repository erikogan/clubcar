class Mood < ActiveRecord::Base
  belongs_to :user
  belongs_to :preference
end
