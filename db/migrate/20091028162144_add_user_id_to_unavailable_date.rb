class AddUserIdToUnavailableDate < ActiveRecord::Migration
  def self.up
    add_column :unavailable_dates, :user_id, :int
  end

  def self.down
    remove_column :unavailable_dates, :user_id
  end
end
