class RenameBlackOutDatesToUnavailableDates < ActiveRecord::Migration
  def self.up
     rename_table :black_out_dates, :unavailable_dates
  end

  def self.down
    rename_table :unavailable_dates, :black_out_dates
  end
end
