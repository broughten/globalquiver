class RemoveStyleFromStyles < ActiveRecord::Migration
  def self.up
    remove_column :styles, :style
  end

  def self.down
    add_column :styles, :style, :string
  end
end
