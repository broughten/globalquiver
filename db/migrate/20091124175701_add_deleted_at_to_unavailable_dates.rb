class AddDeletedAtToUnavailableDates < ActiveRecord::Migration
  def self.up
    add_column :unavailable_dates, :deleted_at, :timestamp, :default => nil
  end

  def self.down
    remove_column :unavailable_dates, :deleted_at
  end
end
