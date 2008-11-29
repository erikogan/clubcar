module TagMixin
  def self.included(base)
    base.extend         ClassMethods
    base.instance_eval { include InstanceMethods }
    RAILS_DEFAULT_LOGGER.info "** TagMixin: #{base.name}"
  end
  
  module ClassMethods
    def find_all_by_bounded_date_distance(not_in = [-1])
      # I need to figure out how to NOT include all the columns in the GROUP BY
      tCols = Tag.columns.reject { |c| c.name == 'name' }.map {|c| "t.#{c.name}"}

      return Tag.find_by_sql(<<-endSQL)
        SELECT  t.*,
                MIN(date_distance) AS distance
        FROM    restaurants AS r
        LEFT JOIN restaurants_date_distance AS rdd
                ON rdd.restaurant_id = r.id,
                taggings AS tg,
                tags AS t
        WHERE   tg.context = 'genres'
                AND t.id NOT IN (#{not_in})
                AND tg.tag_id = t.id
                AND tg.taggable_id = r.id
                AND tg.taggable_type = 'Restaurant'
        GROUP BY t.name, #{tCols.join(', ')}
        -- The 'bounded' part
        HAVING  (MIN(date_distance) > 3 OR MIN(date_distance) IS NULL)
        -- Put the NULLs at the front
        ORDER BY MIN(date_distance) IS NOT NULL, MIN(date_distance), t.name;
      endSQL
    end

    def find_unscored_genres
      # I need to figure out how to NOT include all the columns in the GROUP BY
      tCols = Tag.columns.reject { |c| c.name == 'name' }.map {|c| "t.#{c.name}"}

      return Tag.find_by_sql(<<-endSQL)
        SELECT  t.*, numeric '1' AS weight
        FROM    restaurants AS r
        LEFT JOIN restaurants_date_distance AS rdd
                ON rdd.restaurant_id = r.id,
                taggings AS tg,
                tags AS t
        WHERE   tg.context = 'genres'
                AND tg.tag_id = t.id
                AND tg.taggable_id = r.id
                AND tg.taggable_type = 'Restaurant'
        -- I hate to add this as a special case, but I need to rework the
        -- selection algorithm, and the brought in restaurants nobody wants to
        -- go to are killing the genres
        -- oops, but THAT is leading to duplication, out it goes
                AND r.id NOT IN (SELECT subTG.taggable_id 
                                 FROM   taggings AS subTG, 
                                        tags subT 
                                 WHERE  subT.name = 'brought in' 
                                        AND subTG.tag_id = subT.id
                                        AND subTG.context = 'tags'
                                        AND subTG.taggable_type = 'Restaurant')
        GROUP BY t.name, #{tCols.join(', ')}
        HAVING  (MIN(date_distance) > 3 OR MIN(date_distance) IS NULL)
        ORDER BY t.name
      endSQL
    end

    def find_scored_genres(not_in=[-1])
      # I need to figure out how to NOT include all the columns in the GROUP BY
      tCols = Tag.columns.reject { |c| c.name == 'name' }.map {|c| "t.#{c.name}"}
      # unfortunately, I can't use parameters
      # return Tag.find_by_sql(<<endSQL, @@genre_type.id, not_in)
      not_in = not_in.join ', '

      return Tag.find_by_sql(<<-endSQL)
        SELECT  t.*,
                MIN(date_distance) AS distance,
                SUM(genre_total) AS score,
                SUM(genre_total) / count(r.*) AS score_per_restaurant,
        -- The linear weighting was too much, make it logarithmic (and move it
        -- into the SQL). Everybody gets one point for showing up, thus the 2+score.
                ROUND(#{Restaurant::VOTE_TO_DATE_DISTANCE_RATIO} 
                      * LOG(2, 2+(SUM(genre_total) / COUNT(r.*))) 
                      + LOG(2, 
                            CASE WHEN MIN(date_distance) IS NULL 
                            THEN #{Restaurant::DATE_DISTANCE_MAX} 
                            WHEN MIN(date_distance) > #{Restaurant::DATE_DISTANCE_MAX} 
                            THEN #{Restaurant::DATE_DISTANCE_MAX} 
                            ELSE MIN(date_distance)
                            END
                            )) AS weight
        FROM    restaurants AS r
        LEFT JOIN restaurants_date_distance AS rdd
                ON rdd.restaurant_id = r.id
        LEFT JOIN active_vote_totals AS avt
                ON avt.restaurant_id = r.id,
                taggings AS tg,
                tags AS t
        WHERE   tg.context = 'genres'
                AND t.id NOT IN (#{not_in})
                AND tg.tag_id = t.id
                AND tg.taggable_id = r.id
                AND tg.taggable_type = 'Restaurant'
        -- I hate to add this as a special case, but I need to rework the
        -- selection algorithm, and the brought in restaurants nobody wants to
        -- go to are killing the genres
        -- oops, but THAT is leading to duplication, out it goes
                AND r.id NOT IN (SELECT subTG.taggable_id 
                                 FROM   taggings AS subTG, 
                                        tags subT 
                                 WHERE  subT.name = 'brought in' 
                                        AND subTG.tag_id = subT.id
                                        AND subTG.context = 'tags'
                                        AND subTG.taggable_type = 'Restaurant')
        GROUP BY t.name, #{tCols.join(', ')}
        HAVING  (MIN(date_distance) > 3 OR MIN(date_distance) IS NULL)
                AND SUM(genre_total) >= 0
        ORDER BY t.name
      endSQL
    end
  end
  
  module InstanceMethods
  end
end

Tag.send :include, TagMixin
