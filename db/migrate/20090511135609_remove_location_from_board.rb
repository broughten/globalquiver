class RemoveLocationFromBoard < ActiveRecord::Migration
  def self.up
    remove_column :boards, :street
    remove_column :boards, :locality
    remove_column :boards, :region
    remove_column :boards, :postal_code
    remove_column :boards, :country
  end

  def self.down
    add_column :boards, :country, :string
    add_column :boards, :postal_code, :string
    add_column :boards, :region, :string
    add_column :boards, :locality, :string
    add_column :boards, :street, :string
  end
end
