class AddUserStampColumnsToBoardSearches < ActiveRecord::Migration
  def self.up
    add_column :board_searches, :creator_id, :integer
    add_column :board_searches, :updater_id, :integer
  end

  def self.down
    remove_column :board_searches, :updater_id
    remove_column :board_searches, :creator_id
  end
end
