class AddDeletedAtToReservation < ActiveRecord::Migration
  def self.up
    add_column :reservations, :deleted_at, :timestamp, :default => nil
  end

  def self.down
    remove_column :reservations, :deleted_at
  end
end
