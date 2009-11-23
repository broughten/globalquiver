class AddFriendlyAndUrlToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :friendly, :boolean
    add_column :users, :url, :string
  end

  def self.down
    remove_column :users, :url
    remove_column :users, :friendly
  end
end
