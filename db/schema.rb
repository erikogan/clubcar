# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090615023151) do

  create_table "emails", :force => true do |t|
    t.integer "user_id", :null => false
    t.string  "address", :null => false
  end

  add_index "emails", ["address"], :name => "index_emails_on_email"
  add_index "emails", ["address"], :name => "uniq_email_email", :unique => true

  create_table "moods", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.string  "name",                       :null => false
    t.boolean "active",  :default => false, :null => false
    t.integer "order"
  end

  add_index "moods", ["user_id"], :name => "index_moods_on_user_id"

  create_table "preferences", :force => true do |t|
    t.integer "mood_id",       :null => false
    t.integer "restaurant_id", :null => false
    t.integer "vote_id",       :null => false
  end

  add_index "preferences", ["mood_id"], :name => "index_preferences_on_mood_id"
  add_index "preferences", ["restaurant_id"], :name => "index_preferences_on_restaurant_id"
  add_index "preferences", ["mood_id", "restaurant_id"], :name => "uniq_preferences_mood_restaurant", :unique => true

  create_table "restaurants", :force => true do |t|
    t.string  "name",     :null => false
    t.string  "address"
    t.string  "city"
    t.decimal "distance"
    t.string  "url"
    t.string  "image"
  end

  add_index "restaurants", ["city"], :name => "index_restaurants_on_city"
  add_index "restaurants", ["name"], :name => "index_restaurants_on_name"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :null => false
    t.integer  "taggable_id",   :null => false
    t.string   "taggable_type", :null => false
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :null => false
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["context", "taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "name"
    t.string   "crypted_password",                       :null => false
    t.string   "salt",                                   :null => false
    t.boolean  "present",             :default => false, :null => false
    t.boolean  "admin",               :default => false, :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["present"], :name => "index_users_on_present"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

  create_table "users_wtf", :force => true do |t|
    t.string   "login",                                                                      :null => false
    t.string   "name"
    t.string   "email",                                                                      :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.boolean  "present",                                 :default => false
    t.datetime "created_at",                              :default => '2008-12-15 23:42:13', :null => false
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  create_table "visits", :force => true do |t|
    t.integer "restaurant_id",                :null => false
    t.date    "date",                         :null => false
    t.string  "duration",      :limit => nil
  end

  add_index "visits", ["date"], :name => "index_visits_on_date"
  add_index "visits", ["restaurant_id"], :name => "index_visits_on_restaurant_id"
  add_index "visits", ["date", "restaurant_id"], :name => "uniq_visits_restaurants_date", :unique => true

  create_table "votes", :force => true do |t|
    t.string  "name",        :null => false
    t.integer "value",       :null => false
    t.integer "genre_value", :null => false
  end

  add_index "votes", ["name"], :name => "index_votes_on_name"

end
