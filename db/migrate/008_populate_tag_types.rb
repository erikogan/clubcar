class PopulateTagTypes < ActiveRecord::Migration

  @@types = [ "Tag", "Genre" ]

  def self.up
    @@types.each { |name| TagType.create!(:name => name) }
  end

  def self.down
    @@types.each { |name| TagType.find_by_name(name).destroy }
  end
end
