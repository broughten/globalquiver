class CreatePickupTimes < ActiveRecord::Migration
  def self.up
    create_table :pickup_times do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :pickup_times
  end
end
