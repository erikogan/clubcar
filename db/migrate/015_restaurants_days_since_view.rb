class RestaurantsDaysSinceView < ActiveRecord::Migration
  def self.up
    execute <<EndSQL
CREATE OR REPLACE FUNCTION days_since(date) RETURNS integer AS '
DECLARE
    -- declarations (keep this 7.4 compliant)
    d ALIAS FOR $1;
BEGIN
	return CAST(CAST(''today'' AS date) - d AS integer);
END;
' LANGUAGE plpgsql
EndSQL

    execute <<EndSQL
CREATE OR REPLACE VIEW restaurants_days_since AS
SELECT 	r.id,
		MIN(days_since(v.date)) AS days_since
FROM	restaurants AS r
LEFT JOIN visits AS v
		ON r.id = v.restaurant_id
GROUP BY r.id
EndSQL
  end


  def self.down
    execute "DROP VIEW restaurants_days_since"
    execute "DROP FUNCTION days_since(date)"
  end
end
