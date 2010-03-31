class AddWeeklyFeeToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :weekly_fee, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :boards, :weekly_fee
  end
end
