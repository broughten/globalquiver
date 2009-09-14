class AddLocationIdToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :location_id, :integer
  end

  def self.down
    remove_column :boards, :location_id
  end
end
