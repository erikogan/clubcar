class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :canonical,      :string,        :null => false
      t.column :name,           :string
      t.column :type_id,        :integer,       :null => false
    end
    execute "ALTER TABLE tags ADD CONSTRAINT fk_tag_types FOREIGN KEY (type_id) REFERENCES tag_types(id) ON DELETE CASCADE"
    # Arguably, this should be (type_id, canonical)
    execute "ALTER TABLE tags ADD CONSTRAINT uniq_tags_canonical UNIQUE (canonical)"
    add_index :tags, :type_id
    add_index :tags, :canonical
  end

  def self.down
    drop_table :tags
  end
end
