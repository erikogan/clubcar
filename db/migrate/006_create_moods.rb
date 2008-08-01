class CreateMoods < ActiveRecord::Migration
  def self.up
    create_table :moods do |t|
      t.column :user_id,:integer,	:null => false
      t.column :name,	:string,	:null => false
      t.column :active,	:boolean,	:null => false,	:default => false
      t.column :order,	:integer
    end

    execute "ALTER TABLE moods ADD CONSTRAINT fk_mood_users FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"

    add_index :moods, :user_id
  end

  def self.down
    drop_table :moods
  end
end
