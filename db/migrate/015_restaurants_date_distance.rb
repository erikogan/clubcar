class RestaurantsDateDistance < ActiveRecord::Migration
  def self.up
execute <<EndSQL
CREATE OR REPLACE VIEW restaurants_date_distance AS
SELECT 	r.id as restaurant_id,
	MIN(ABS(date_mi(CAST('today' AS date), v.date))) AS date_distance
FROM	restaurants AS r
LEFT JOIN visits AS v
	ON r.id = v.restaurant_id
GROUP BY r.id
EndSQL
  end


  def self.down
    execute "DROP VIEW restaurants_date_distance"
  end
end
