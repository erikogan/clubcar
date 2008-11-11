require 'active_record/fixtures'

class PopulateVotes < ActiveRecord::Migration
  def self.up
    Fixtures.create_fixtures('test/fixtures', 
                             File.basename("votes.yml", '.*'))

  end

  def self.down
    execute "TRUNCATE votes"
  end
end
