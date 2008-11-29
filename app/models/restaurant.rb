class Restaurant < ActiveRecord::Base
  has_many :preferences, :dependent => :destroy
  has_many :visits, :dependent => :destroy

  acts_as_taggable_on :tags
  acts_as_taggable_on :genres
  
  # This should be configurable (note, setting this value to < 0.5 could
  # cause collisions in the algorithm below)
  VOTE_TO_DATE_DISTANCE_RATIO = 4.0
  
  # This, too, should be configurable
  DATE_DISTANCE_MAX = 14 # (after two weeks, does it really matter?)

  def to_s()
    self.name
  end

  def tags_string()
    tag_list.join(", ")
  end

  def tags_string=(str) 
    self.tag_list = str
    self
  end

  def genres_string()
    genre_list.join(", ")
  end

  def genres_string=(str) 
    self.genre_list = str
    self
  end

  def self.find_all_by_tags_with_active_scores(tags = [-1])
    noID = Restaurant.columns.reject { |c| c.name == 'id' }.map {|c| "r.#{c.name}"}

    find_by_sql(<<EndSQL)
SELECT  DISTINCT(r.id), #{noID.join ', '}, 
        avt.total,
-- The linear weighting was too much, make it logarithmic (and move it
-- into the SQL). Everybody gets one point for showing up, thus the 2+score.
        ROUND(#{VOTE_TO_DATE_DISTANCE_RATIO} 
              * LOG(2, 2 + CASE WHEN total IS NULL THEN 0
                                ELSE total
                           END)
              + LOG(2, CASE WHEN date_distance IS NULL 
                                THEN #{DATE_DISTANCE_MAX}
                            WHEN date_distance > #{DATE_DISTANCE_MAX} 
                                THEN #{DATE_DISTANCE_MAX} 
                            ELSE date_distance
                        END)
              ) AS weight
FROM    taggings AS t,
        restaurants AS r
LEFT JOIN active_vote_totals AS avt
        ON avt.restaurant_id = r.id
LEFT JOIN restaurants_date_distance rdd
        ON rdd.restaurant_id = r.id
WHERE   t.tag_id IN (#{tags.map {|t| t.id}.join ', '})
        AND t.taggable_id = r.id
        AND t.taggable_type = 'Restaurant'
        AND (avt.total >= 0 OR avt.total IS NULL)
ORDER BY r.name
EndSQL
  end
end

