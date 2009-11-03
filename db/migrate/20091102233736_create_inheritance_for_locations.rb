class CreateInheritanceForLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :object_type, :string
    add_column :locations, :search_radius, :int
  end

  def self.down
    remove_column :locations, :object_type
    remove_column :locations, :search_radius
  end
end
