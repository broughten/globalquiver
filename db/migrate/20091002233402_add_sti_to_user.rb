class AddStiToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :type
  end
end
