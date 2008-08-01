class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.column :user_id,	:integer,	:null => false
      t.column :email,		:string,	:null => false
      # Eventually add booleans like primary, verified, etc.
    end
    add_index :emails, :email

    execute "ALTER TABLE emails ADD CONSTRAINT fk_email_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
    execute "ALTER TABLE emails ADD CONSTRAINT uniq_email_email UNIQUE (email)"
  end

  def self.down
    drop_table :emails
  end
end
