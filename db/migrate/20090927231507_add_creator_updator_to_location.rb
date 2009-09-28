class AddCreatorUpdatorToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :creator_id, :integer
    add_column :locations, :updater_id, :integer
  end

  def self.down
    remove_column :locations, :updater_id
    remove_column :locations, :creator_id
  end
end
