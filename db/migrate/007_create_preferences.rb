class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :mood_id, :integer
      t.column :restaurant_id, :integer
      t.column :value, :integer
    end
  end

  def self.down
    drop_table :preferences
  end
end
