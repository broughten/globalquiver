class IntToFloatForBoards < ActiveRecord::Migration
  def self.up
    change_column :boards, :width, :float
    change_column :boards, :thickness, :float
  end

  def self.down
    change_column :boards, :width, :integer
    change_column :boards, :thickness, :integer
  end
end
