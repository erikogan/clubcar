class PopulateUsers < ActiveRecord::Migration

  @@users = [ 
    { 
      :login => "erik",
      :name => "Erik Ogan",
      :pwd => "foobar"
    },
    { 
      :login => "test",
      :name => "Test Account",
      :pwd => "testing"
    }
  ]

  def self.up
    @@users.each { |values| 
      values[:plain_password] = values[:pwd]
      values[:plain_password_confirmation] = values[:pwd]
      values.delete(:pwd)

      User.create!(values) 
    }
  end

  def self.down
    @@users.each { |values| User.find_by_login(values[:login]).destroy }
  end
end
