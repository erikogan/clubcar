# Move this to a constant, so I can included it from 020...
ACTIVE_VOTE_TOTALS_SQL = <<EndSQL
CREATE OR REPLACE VIEW active_vote_totals AS
SELECT 	ap.restaurant_id,
	SUM(v.value) AS total
FROM	active_preferences AS ap,
	votes AS v
WHERE	ap.vote_id = v.id
GROUP BY restaurant_id
EndSQL

class ActiveVoteTotals < ActiveRecord::Migration
  def self.up
    execute ACTIVE_VOTE_TOTALS_SQL
  end

  def self.down
    execute "DROP VIEW active_vote_totals"
  end
end
