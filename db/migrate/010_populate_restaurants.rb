class PopulateRestaurants < ActiveRecord::Migration

  @@restaurants = [
    { :name => "Zibibbo",
      :city => "Palo Alto"
    },
    {
      :name => "Le Boulanger",
      :city => "Sunnyvale"
    }
  ]

  def self.up
    @@restaurants.each { |h| Restaurant.create!(h) }
  end

  def self.down
    @@restaurants.each { |h| Restaurant.find_by_name(h[:name]).destroy }
  end
end
