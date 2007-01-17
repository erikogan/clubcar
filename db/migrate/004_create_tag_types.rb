class CreateTagTypes < ActiveRecord::Migration
  def self.up
    create_table :tag_types do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :tag_types
  end
end
