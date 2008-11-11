class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.column :restaurant_id,  :integer,       :null => false
      t.column :date,           :date,          :null => false
      t.column :duration,       :interval
    end

    execute "ALTER TABLE visits ADD CONSTRAINT fk_visits_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE"

    # doing this above with :default => 'now()' does NOT DtRT
    execute "ALTER TABLE visits ALTER COLUMN date SET DEFAULT now()"

    # It could be argued that the unique constraint should be on date,
    # but we may have multiple groups going different places on the same
    # day.
    execute "ALTER TABLE visits ADD CONSTRAINT uniq_visits_restaurants_date UNIQUE (restaurant_id,date)"

    add_index :visits, :restaurant_id
    add_index :visits, :date

  end

  def self.down
    drop_table :visits
  end
end
