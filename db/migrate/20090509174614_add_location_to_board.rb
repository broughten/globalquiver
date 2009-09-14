class AddLocationToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :street, :string
    add_column :boards, :locality, :string
    add_column :boards, :region, :string
    add_column :boards, :postal_code, :string
    add_column :boards, :country, :string
  end

  def self.down
    remove_column :boards, :country
    remove_column :boards, :postal_code
    remove_column :boards, :region
    remove_column :boards, :locality
    remove_column :boards, :street
  end
end
