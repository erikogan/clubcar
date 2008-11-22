class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    #create_table :tags do |t|
    #  t.column :name, :string
    #end
    add_index :tags :name

    create_table :taggings do |t|
      t.column :tag_id, :integer, :null => false
      t.column :taggable_id, :integer, :null => false
      t.column :taggable_type, :string, :null => false
      t.column :tagger_id, :integer
      t.column :tagger_type, :string
      
      t.column :context, :string, :null => false
      t.column :created_at, :datetime
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    execute "ALTER TABLE taggings ADD CONSTRAINT fk_tagging_tags FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE"
    
    execute <<-EndSQL
      INSERT INTO taggings (tag_id, taggable_id, taggable_type, context, created_at)
      SELECT  tag_id, restaurant_id, 'Restaurant', lower(tt.name || 's'), now()
      FROM    labels AS l,
              tags AS t,
              tag_types AS tt
      WHERE l.tag_id = t.id
            AND t.type_id = tt.id
      ORDER BY  restaurant_id, tag_id
    EndSQL
    
    remove_column :tags, :canonical
    remove_column :tags, :type_id

    drop_table :labels
    drop_table :tag_types
  end
  
  def self.down
    
    create_table :tag_types do |t|
      t.column :name,           :string,  :null => false
    end
    
    create_table :labels do |t|
      t.column :restaurant_id,  :integer, :null => false
      t.column :tag_id,         :integer, :null => false
    end

    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_restaurants FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE"
    execute "ALTER TABLE labels ADD CONSTRAINT fk_label_tags FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE"
    execute "ALTER TABLE labels ADD CONSTRAINT uniq_label_restaurant_tag UNIQUE (tag_id,restaurant_id)"

    add_index :labels, :restaurant_id
    add_index :labels, :tag_id
    
    add_column :tags, :canonical, :string
    add_column :tags, :type_id, :integer
    
    execute <<-EndSQL
      INSERT  INTO tag_types (name)
      SELECT  distinct(initcap(rtrim(context,'s')))
      FROM    taggings
    EndSQL

    execute <<-EndSQL
      INSERT  INTO labels (restaurant_id, tag_id)
      SELECT  taggable_id, tag_id
      FROM    taggings
    EndSQL

    # TODO: This will break if a tag is used in more than one context (as a tag and genre)
    execute <<-EndSQL
      UPDATE  tags AS t
      SET     type_id = (SELECT  id
                         FROM    tag_types AS tt
                         WHERE   name = (SELECT  distinct(initcap(rtrim(context,'s'))) AS name
                                         FROM    taggings AS tg
                                         WHERE   tag_id = t.id
                                         LIMIT   1)
                        ),
              canonical = REPLACE(LOWER(name), ' ', '')
    EndSQL
    
    execute "ALTER TABLE tags ADD CONSTRAINT fk_tag_types FOREIGN KEY (type_id) REFERENCES tag_types(id) ON DELETE CASCADE"
    # Arguably, this should be (type_id, canonical)
    execute "ALTER TABLE tags ADD CONSTRAINT uniq_tags_canonical UNIQUE (canonical)"
    
    drop_table :taggings
    #drop_table :tags
  end
end
