class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.column :name, :string, :null => false
      t.column :address, :string
      t.column :city, :string
      t.column :distance, :decimal
      t.column :image, :string
    end
  end

  def self.down
    drop_table :restaurants
  end
end
