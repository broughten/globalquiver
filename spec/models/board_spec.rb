require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec_helper'

describe Board do

  it "should create a new instance from blueprint" do
    Board.make().should be_valid
  end
  
  describe "associations" do
    it "should have a style" do
      Board.make().should respond_to(:style)
    end
    
    it "should have a location" do
      Board.make().should respond_to(:location)
    end
    
    it "should have a creator" do
      Board.make().should respond_to(:creator)
    end
    
    it "should have an updater" do
      Board.make().should respond_to(:updater)
    end
    
    it "should have many images" do
      Board.make().should respond_to(:images)
    end
    
    it "should have many black_out_dates" do
      make_board_with_black_out_dates.should respond_to(:black_out_dates)
    end
  end
  
  describe "validations" do
    it "should validate location" do
      board = Board.make_unsaved(:location=>Location.make())
      board.should be_valid
      
      board.location = nil
      board.should_not be_valid
    end
    
    it "should validate length" do
      board = Board.make_unsaved(:length=>100)
      board.should be_valid
      
      board.length = nil
      board.should_not be_valid
      
    end
    
    it "should validate maker" do
      board = Board.make_unsaved(:maker=>"Test Maker")
      board.should be_valid
      
      board.maker = ""
      board.should_not be_valid
    end
    
    it "should validate style" do
      board = Board.make_unsaved(:style=>Style.make())
      board.should be_valid
      
      board.style = nil
      board.should_not be_valid
    end
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
