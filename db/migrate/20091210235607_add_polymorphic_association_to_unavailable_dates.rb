class AddPolymorphicAssociationToUnavailableDates < ActiveRecord::Migration
  def self.up
    rename_column :unavailable_dates, :board_id, :parent_id
    add_column :unavailable_dates, :parent_type, :string
  end

  def self.down
    rename_column :unavailable_dates, :parent_id, :board_id
    remove_column :unavailable_dates, :parent_type
  end
end
