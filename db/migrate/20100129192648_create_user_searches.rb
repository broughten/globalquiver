class CreateUserSearches < ActiveRecord::Migration
  def self.up
    create_table :user_searches do |t|
      t.string :terms
      t.integer :location_id
      t.integer :updater_id
      t.integer :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_searches
  end
end
