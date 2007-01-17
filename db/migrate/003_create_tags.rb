class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
      t.column :display_name, :string
      t.column :type_id, :integer
    end
    execute "ALTER TABLE tags ADD CONSTRAINT fk_tag_types FOREIGN KEY (type_id) REFERENCES tag_types(id)"
  end

  def self.down
    drop_table :tags
  end
end
