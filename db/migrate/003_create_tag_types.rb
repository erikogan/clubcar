class CreateTagTypes < ActiveRecord::Migration
  def self.up
    create_table :tag_types do |t|
      t.column :name, :string, :null => false
    end

    execute "ALTER TABLE tag_types ADD CONSTRAINT uniq_tag_types_name UNIQUE (name)"
  end

  def self.down
    drop_table :tag_types
  end
end
