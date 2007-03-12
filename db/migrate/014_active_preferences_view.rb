class ActivePreferencesView < ActiveRecord::Migration
  def self.up
    execute <<EndSQL
CREATE OR REPLACE VIEW active_preferences AS
SELECT	p.*
FROM	preferences AS p,
	moods AS m,
	users AS u
WHERE	p.mood_id = m.id
	AND m.user_id = u.id
	AND u.present = true
	AND m.active = true
EndSQL
  end

  def self.down
    execute "DROP VIEW active_preferences"
  end
end
