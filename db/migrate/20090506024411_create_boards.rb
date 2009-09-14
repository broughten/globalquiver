class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.string :maker
      t.string :model
      t.integer :length
      t.integer :width
      t.integer :thickness
      t.integer :style_id
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
