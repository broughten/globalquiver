class AddSearchTypeToUserSearches < ActiveRecord::Migration
  def self.up
    add_column :user_searches, :search_type, :string, :limit => 30
  end

  def self.down
    remove_column :user_searches, :search_type
  end
end
