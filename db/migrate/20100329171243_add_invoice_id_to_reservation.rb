class AddInvoiceIdToReservation < ActiveRecord::Migration
  def self.up
    add_column :reservations, :invoice_id, :integer
  end

  def self.down
    remove_column :reservations, :invoice_id
  end
end
