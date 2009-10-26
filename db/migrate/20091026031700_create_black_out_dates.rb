class CreateBlackOutDates < ActiveRecord::Migration
  def self.up
    create_table :black_out_dates do |t|
      t.column :board_id, :integer
      t.column :date, :date

      t.timestamps
    end
    add_index :black_out_dates, [:board_id, :date], :unique => true
  end

  def self.down
    drop_table :black_out_dates
  end
end
