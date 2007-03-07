class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :name, :string, :null => false
      t.column :value, :integer, :null => false
    end
    
    add_index :votes, :name
  end

  def self.down
    drop_table :votes
  end
end
