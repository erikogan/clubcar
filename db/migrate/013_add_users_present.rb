class AddUsersPresent < ActiveRecord::Migration
  def self.up
    add_column :users, :present, :boolean, :null => false, :default => false

    # The default is false, but everyone added thus far should be true,
    # since it hasn't been an option before
    execute "UPDATE users set present = true"

    # Since we'll be using it in views (move it below the update, since
    # it's faster to update a non-indexed column)
    add_index :users, :present
  end

  def self.down
    remove_column :users, :present
  end
end
