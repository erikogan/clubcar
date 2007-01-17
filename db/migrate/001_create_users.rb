class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string
      t.column :name, :string
      t.column :password, :string
    end
  end

  def self.down
    drop_table :users
  end
end
