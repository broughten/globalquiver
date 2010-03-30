class AddReservationInvoiceFeeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :reservation_invoice_fee, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :users, :reservation_invoice_fee
  end
end
