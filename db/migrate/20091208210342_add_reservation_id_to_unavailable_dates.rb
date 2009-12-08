class AddReservationIdToUnavailableDates < ActiveRecord::Migration
  def self.up
    add_column :unavailable_dates, :reservation_id, :integer
  end

  def self.down
    remove_column :unavailable_dates, :reservation_id
  end
end
