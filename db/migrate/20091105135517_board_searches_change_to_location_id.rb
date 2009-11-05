class BoardSearchesChangeToLocationId < ActiveRecord::Migration
  def self.up
    add_column :board_searches, :location_id, :int
    remove_column :board_searches, :geocode_id
  end

  def self.down
    remove_column :board_searches, :location_id
    add_column :board_searches, :geocode_id, :int
  end
end
