class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :mood_id, :integer, :null => false
      t.column :restaurant_id, :integer, :null => false
      t.column :value, :integer, :null => false, :default => 0
    end

    execute "ALTER TABLE preferences ADD CONSTRAINT fk_preference_moods FOREIGN KEY (mood_id) REFERENCES moods(id)"

    execute "ALTER TABLE preferences ADD CONSTRAINT fk_preferences_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)"

  end

  def self.down
    drop_table :preferences
  end
end
