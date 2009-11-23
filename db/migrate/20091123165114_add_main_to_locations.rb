class AddMainToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :main, :boolean
  end

  def self.down
    remove_column :locations, :main
  end
end
