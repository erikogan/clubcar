class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login,          :string, :null => false
      t.column :name,           :string
      t.column :password,       :string, :null => false
      t.column :salt,           :string, :null => false
    end
    add_index :users, :login
  end

  def self.down
    drop_table :users
  end
end
