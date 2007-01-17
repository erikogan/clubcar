class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
      t.column :display_name, :string
      t.column :type_id, :integer
    end
  end

  def self.down
    drop_table :tags
  end
end
