require File.dirname(__FILE__) + '/../spec_helper'

describe BoardSearch do
  it "should be valid from the blueprint" do
    BoardSearch.make()
  end
  
  describe "associations" do
    it "should have a style" do
      BoardSearch.make_unsaved().should respond_to(:style)
    end
    
    it "should have a location" do
      BoardSearch.make_unsaved().should respond_to(:location)
    end
  end
  
  describe "validations" do
    it_should_validate_presence_for_attributes BoardSearch.make_unsaved(), :location
  end
  
  describe "methods" do
    it "should respond to an execute method" do
      board_search = BoardSearch.make()
      board_search.should respond_to(:execute)
    end
    
    it "execute should return an array" do
      board_search = make_board_search()
      results = board_search.execute
      results.class.should ==  Array.new.class
    end
    
    it "execute should filter results based on location" do
      board1 = Board.make(:location=>BoardLocation.make(:geocodable))
      board2 = Board.make(:location=>board1.location)
      board2.location = board1.location
      board2.save
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location)
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_true
      #change location
      board2.location = BoardLocation.make(:geocodable2)
      # make sure you save the new state away into the db.
      board2.save 
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_false 
    end

    it "execute should filter results based on style" do
      board1 = Board.make(:location=>BoardLocation.make(:geocodable))
      board2 = Board.make(:location=>board1.location)
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location,:style=>nil)
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_true
      
      #change board_search style to something 
      board_search.style = board1.style
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_false
      end
    end
  
  
end
