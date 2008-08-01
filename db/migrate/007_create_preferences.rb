class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :mood_id,	:integer, :null => false
      t.column :restaurant_id,	:integer, :null => false
      t.column :value,		:integer, :null => false, :default => Preference::NEUTRAL
    end

    execute "ALTER TABLE preferences ADD CONSTRAINT fk_preferences_moods FOREIGN KEY (mood_id) REFERENCES moods(id) ON DELETE CASCADE"

    execute "ALTER TABLE preferences ADD CONSTRAINT fk_preferences_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE"

    execute "ALTER TABLE preferences ADD CONSTRAINT uniq_preferences_mood_restaurant UNIQUE (mood_id,restaurant_id)"

    add_index :preferences, :mood_id
    add_index :preferences, :restaurant_id
  end

  def self.down
    drop_table :preferences
  end
end
