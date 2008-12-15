class Mood < ActiveRecord::Base
  belongs_to :user
  has_many :preferences, :dependent => :destroy
  has_many :restaurants, :through => :preferences

  attr_protected :active

  named_scope :active, :conditions => ['active = true']

  VETO_MAX = 3

  VETO_ID = Vote.find_by_name('Veto').id

  def validate
    # This looks at the SQL
    #if (self.preferences.find_all_by_vote_id(VETO_ID).length > VETO_MAX)
    # puts "WTF: #{self.preferences.select { |p| p.vote_id == VETO_ID }.length} : #{VETO_MAX} | #{VETO_ID}"
    if (self.preferences.select { |p| p.vote_id == VETO_ID }.length > VETO_MAX)
      errors.add_to_base("You are only allowed #{VETO_MAX} vetoes!")
    end
  end

  def activate
    Mood.transaction do 
      Mood.connection.update("UPDATE moods set active = false where user_id = #{self.user_id}")
      self.active = true
      self.save!
    end
  end

end
