class CreateMoods < ActiveRecord::Migration
  def self.up
    create_table :moods do |t|
      t.column :user_id, :integer
      t.column :name, :string
      t.column :sort_order, :integer
    end
  end

  def self.down
    drop_table :moods
  end
end
