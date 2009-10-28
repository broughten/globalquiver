class UnavailableDatesReplaceUserWithCreatorAndUpdater < ActiveRecord::Migration
  def self.up
    remove_column :unavailable_dates, :user_id
    add_column :unavailable_dates, :creator_id, :integer
    add_column :unavailable_dates, :updater_id, :integer
  end

  def self.down
    add_column :unavailable_dates, :user_id, :int
    remove_column :unavailable_dates, :updater_id
    remove_column :unavailable_dates, :creator_id
  end
end
