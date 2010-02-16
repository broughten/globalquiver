class AddTypeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :type, :string
  end

  def self.down
    remove_column :boards, :type
  end
end
