require 'spec_helper'

describe Board do

  it "should create a new instance from blueprint" do
    Board.make().should be_valid
  end
  
  it "should determine if it has an existing location" do
    board = Board.make()
    board.has_location?.should be_true
    
    board.location = nil
    board.has_location?.should be_false
    
    board.location_id = -1
    board.has_location?.should be_false
  end
end
