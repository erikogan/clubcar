class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.column :restaurant_id,	:integer,	:null => false
      t.column :date,		:date,		:null => false
      t.column :duration,	:interval
    end

    execute "ALTER TABLE visits ADD CONSTRAINT fk_visits_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)"

    # doing this above with :default => 'now()' does NOT DtRT
    execute "ALTER TABLE visits ALTER COLUMN date SET DEFAULT now()"

    add_index :visits, :restaurant_id
    add_index :visits, :date

  end

  def self.down
    drop_table :visits
  end
end
