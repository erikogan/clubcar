class AddGenreScoreToVotes < ActiveRecord::Migration
  def self.up
    ### The problem with using the normal value for genre calcuations is
    ### that a veto will probably knock out an entire genre. So for the
    ### purposes of genre, a veto is considered a negative vote. (I'm
    ### not sure this is the best way to go, but it gets the job done)

    add_column :votes, :genre_value, :integer, :default => 0, :null => false
    update 'UPDATE votes SET genre_value = value'
    update 'UPDATE votes SET genre_value = -1 WHERE genre_value < -1'

    change_column :votes, :genre_value, :integer, :default => nil

    # PGError: ERROR:  cannot change number of columns in view
    execute 'DROP VIEW active_vote_totals'

    # I could make this a modification of ACTIVE_VOTE_TOTALS_SQL, but
    # that seems silly...though still tempting
    execute <<EndSQL
CREATE OR REPLACE VIEW active_vote_totals AS
SELECT  ap.restaurant_id,
        SUM(v.value) AS total,
        SUM(v.genre_value) AS genre_total
FROM    active_preferences AS ap,
        votes AS v
WHERE   ap.vote_id = v.id
GROUP BY restaurant_id
EndSQL
  end

  def self.down
    # Stay DRY
    require "#{RAILS_ROOT}/db/migrate/016_active_vote_totals"

    # PGError: ERROR:  cannot change number of columns in view
    execute 'DROP VIEW active_vote_totals'

    execute ACTIVE_VOTE_TOTALS_SQL

    remove_column :votes, :genre_value
  end
end
