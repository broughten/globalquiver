class AddPurchaseBuyBackFieldsToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :purchase_price, :decimal, :precision => 8, :scale => 2
    add_column :boards, :buy_back_price, :decimal, :precision => 8, :scale => 2
    add_column :boards, :for_purchase, :boolean, :default => false
  end

  def self.down
    remove_column :boards, :purchase_price
    remove_column :boards, :buy_back_price
    remove_column :boards, :for_purchase
  end
end
