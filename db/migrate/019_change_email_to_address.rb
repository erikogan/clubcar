class ChangeEmailToAddress < ActiveRecord::Migration
  def self.up
    # It seems like there should be a way to do this with the migration
    execute "ALTER TABLE emails RENAME COLUMN email TO address"
  end

  def self.down
    execute "ALTER TABLE emails RENAME COLUMN address TO email"
  end
end
