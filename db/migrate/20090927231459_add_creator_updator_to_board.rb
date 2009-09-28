class AddCreatorUpdatorToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :creator_id, :integer
    add_column :boards, :updater_id, :integer
  end

  def self.down
    remove_column :boards, :updater_id
    remove_column :boards, :creator_id
  end
end
