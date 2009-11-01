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
    
    it "should have many unavailable_dates" do
      make_board_with_unavailable_dates.should respond_to(:unavailable_dates)
    end

    it "should have many reserved dates" do
      make_board_with_unavailable_dates.should respond_to(:reserved_dates)
    end

    it "should have many black out dates" do
      make_board_with_unavailable_dates.should respond_to(:black_out_dates)
    end

    it "reserved dates should only contain dates assigned to board renters" do
      owner = User.make()
      renter = User.make()
      board = Board.make(:creator=>owner)
      1.times {board.unavailable_dates << UnavailableDate.make(:creator=>owner)}
      2.times {board.unavailable_dates << UnavailableDate.make(:creator=>renter)}
      board.reserved_dates.length.should == 2
    end

    it "black out dates should only contain dates assigned to board owner" do
      owner = User.make()
      renter = User.make()
      board = Board.make(:creator=>owner)
      1.times {board.unavailable_dates << UnavailableDate.make(:creator=>owner)}
      2.times {board.unavailable_dates << UnavailableDate.make(:creator=>renter)}
      board.black_out_dates.length.should == 1
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

  describe "nested attributes" do
    it 'should should accept nested attributes for unavailable dates' do
      Board.make().should respond_to(:unavailable_dates_attributes=)
    end

    it 'should should accept nested attributes for images' do
      Board.make().should respond_to(:images_attributes=)
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
  
  describe "class methods" do
    it "should respond to a perform_search method" do
      Board.should respond_to(:perform_search)
    end
    
    it "perform_search should return an array" do
      board_search = BoardSearch.make()
      results = Board.perform_search(board_search)
      results.class.should ==  Array.new.class
    end
    
    # it "perform_search should filter results based on board_search.geocode" do
    #               board1 = Board.make(:geocodable)
    #               board2 = Board.make(:geocodable)
    #               board2.location = board1.location
    #               board_search = BoardSearch.make(:geocode=>board1.location.geocode)
    #               result = Board.perform_search(board_search)
    #               result.include?(board1).should be_true
    #               result.include?(board2).should be_true
    #               
    #               #change location
    #               board2.location = Location.make(:geocodable2) 
    #               debugger
    #               result = Board.perform_search(board_search)
    #               result.include?(board1).should be_true
    #               result.include?(board2).should be_false
    #             end
    #     
    it "perform_search should filter results based on board_search.style" do
      board1 = Board.make()
      board2 = Board.make()
      board_search = BoardSearch.make(:style=>nil)
      result = Board.perform_search(board_search)
      debugger
      result.include?(board1).should be_true
      result.include?(board2).should be_true
      
      #change board_search style to something 
      board_search.style = board1.style
      result = Board.perform_search(board_search)
      result.include?(board1).should be_true
      result.include?(board2).should be_false
      end
    end
end
