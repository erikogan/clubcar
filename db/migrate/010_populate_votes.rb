require 'active_record/fixtures'

class PopulateVotes < ActiveRecord::Migration
  def self.up
    Fixtures.create_fixtures('test/fixtures', 
			     File.basename("votes.yml", '.*'))

    add_column :preferences, :vote_id, :integer
    execute "ALTER TABLE preferences ADD CONSTRAINT fk_preferences_votes FOREIGN KEY (vote_id) REFERENCES votes(id)"
    
    # This is a one-shot, it can afford to be inefficient
    execute "UPDATE preferences SET vote_id = (SELECT id FROM votes AS v WHERE v.value = preferences.value)"

    # Avoid the null violation - delete anything that doesn't match
    # (which should be nothing)
    execute "DELETE FROM preferences WHERE vote_id IS NULL"

    # This doesn't work
    # change_column :preferences, :vote_id, :integer, {:null => false};
    execute "ALTER TABLE preferences ALTER COLUMN vote_id SET NOT NULL"

    remove_column :preferences, :value

  end

  def self.down
    add_column :preferences, :value, :integer, :null => false, :default => 0

    execute "UPDATE preferences SET value = (SELECT value FROM  votes AS v WHERE v.id = preferences.vote_id)"

    remove_column :preferences, :vote_id
    execute "TRUNCATE votes"
  end
end
