class AddDailyFeeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :daily_fee, :money
  end

  def self.down
    remove_column :boards, :daily_fee
  end
end
