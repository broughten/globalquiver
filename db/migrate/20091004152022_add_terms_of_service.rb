class AddTermsOfService < ActiveRecord::Migration
  def self.up
    add_column :users, :terms_of_service, :bool
  end

  def self.down
    remove_column :users, :terms_of_service
  end
end
