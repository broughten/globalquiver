class AddInactiveFieldToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :inactive, :boolean, :default => false
  end

  def self.down
    delete_column :boards, :inactive
  end
end
