class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.column :restaurant_id,	:integer, :null => false
      t.column :tag_id,		:integer, :null => false
    end

    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE"

    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_tags FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE"
    
    execute "ALTER TABLE labels ADD CONSTRAINT uniq_label_restaurant_tag UNIQUE (tag_id,restaurant_id)"

    add_index :labels, :restaurant_id
    add_index :labels, :tag_id
  end

  def self.down
    drop_table :labels
  end
end
