class PopulatePreferences < ActiveRecord::Migration

  @@erik = User.find_by_login("erik");
  @@default = @@erik.moods.find_by_name("default")
  @@zibibbo = Restaurant.find_by_name("Zibibbo")

  def self.up
    pref = Preference.new(:mood_id => @@default.id, 
			  :restaurant_id => @@zibibbo.id, 
			  :value => Preference::POSITIVE)

    @@default.preferences << pref;
  end

  def self.down
    pref = @@default.preferences.find_by_restaurant_id(@@zibibbo.id)
    pref.destroy
    @@default.preferences.delete(pref)
  end
end
