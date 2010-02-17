class AddUpperAndLowerLerLengthToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :upper_length, :integer
    add_column :boards, :lower_length, :integer
  end

  def self.down
    remove_column :boards, :lower_length
    remove_column :boards, :upper_length
  end
end
