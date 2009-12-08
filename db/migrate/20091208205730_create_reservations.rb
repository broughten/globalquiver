class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :board_id
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
