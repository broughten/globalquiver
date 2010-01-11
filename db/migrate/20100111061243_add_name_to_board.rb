class AddNameToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :name, :string
  end

  def self.down
    remove_column :boards, :name
  end
end
