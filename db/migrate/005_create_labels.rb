class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.column :restaurant_id, :integer
      t.column :tag_id, :integer
    end
  end

  def self.down
    drop_table :labels
  end
end
