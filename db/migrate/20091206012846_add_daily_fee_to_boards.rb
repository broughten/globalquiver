class AddDailyFeeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :daily_fee, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :boards, :daily_fee
  end
end
