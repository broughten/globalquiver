class RemoveMainFromLocations < ActiveRecord::Migration
  def self.up
    remove_column :locations, :main
  end

  def self.down
    add_column :locations, :main, :boolean
  end
end
