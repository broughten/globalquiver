class RemoveDeletedAtFromUnavailableDates < ActiveRecord::Migration
  def self.up
    # this is no longer needed since we aren't doing soft delete on unavailable dates anymore
    remove_column :unavailable_dates, :deleted_at
  end

  def self.down
    add_column :unavailable_dates, :deleted_at, :timestamp, :default => nil
  end
end
