class CreateBoardSearches < ActiveRecord::Migration
  def self.up
    create_table :board_searches do |t|
      t.integer :geocode_id
      t.string :board_type
      t.timestamps
    end
  end
  
  def self.down
    drop_table :board_searches
  end
end
