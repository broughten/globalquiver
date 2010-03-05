class AddTypeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :type, :string, :default => "SpecificBoard"
  end

  def self.down
    remove_column :boards, :type
  end
end
