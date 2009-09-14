class AddConstructionToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :construction, :string
  end

  def self.down
    remove_column :boards, :construction
  end
end
