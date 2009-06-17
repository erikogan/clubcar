class AuthLogicUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :password, :crypted_password
    
    tokens = [:persistence_token, :single_access_token, :perishable_token]

    tokens.each do |t|
      add_column :users, t, :string
    end
    
    User.reset_column_information

    say_with_time "Creating tokens for all users" do 
      ActiveRecord::Migration.verbose = false
      User.find(:all).each do |u|
        tokens.each do |t|
          u.send "reset_#{t}"
          # Authlogic looks users up by these tokens if they're present, so it
          # now thinks these objects are new. Resorting to execute
          execute "UPDATE users SET #{t}=E'#{u.send t}' WHERE id=#{u.id}"
        end
        # u.save!
      end
      ActiveRecord::Migration.verbose = true
    end
    
    # Loop over all users and make the tokens
    tokens.each do |t|
      execute "ALTER TABLE users ALTER COLUMN #{t} SET NOT NULL"
    end

    add_column :users, :login_count,        :integer, :null => false, :default => 0
    add_column :users, :failed_login_count, :integer, :null => false, :default => 0
    add_column :users, :current_login_at,   :datetime
    add_column :users, :last_login_at,      :datetime
    # add_column :users :current_login_ip,  :string
    # add_column :users :last_login_ip,  :string
    
    add_index :users, :persistence_token
    add_index :users, :perishable_token
    add_index :users, :single_access_token
    # add_index :users, :last_request_at
  end
  
  def self.down
    [:persistence_token, :single_access_token, :perishable_token, 
      :login_count, :failed_login_count,
      :current_login_at, :last_login_at
      # , :current_login_ip, :last_login_ip
      ].each do |col|
        remove_column :users, col
      end
    rename_column :users, :crypted_password, :password
  end
end
