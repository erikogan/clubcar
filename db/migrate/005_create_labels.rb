class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.column :restaurant_id, :integer, :null => false
      t.column :tag_id, :integer, :null => false
    end

    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)"

    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_tags FOREIGN KEY (tag_id) REFERENCES tags(id)"

  end

  def self.down
    drop_table :labels
  end
end
