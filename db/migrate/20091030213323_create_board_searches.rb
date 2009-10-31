class CreateBoardSearches < ActiveRecord::Migration
  def self.up
    create_table :board_searches do |t|
      t.integer :geocode_id
      t.integer :style_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :board_searches
  end
end
