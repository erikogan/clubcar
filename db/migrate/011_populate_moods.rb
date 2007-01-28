class PopulateMoods < ActiveRecord::Migration

  @@erik = User.find_by_login("erik");


  def self.up
    mood = Mood.new(:name => "default");
    @@erik.moods << mood;
  end

  def self.down
    mood = Mood.find_by_name("default")
    mood.destroy
    @@erik.moods.delete(mood)
  end
end
