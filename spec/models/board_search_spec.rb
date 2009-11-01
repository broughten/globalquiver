require File.dirname(__FILE__) + '/../spec_helper'

describe BoardSearch do
  it "should be valid from the blueprint" do
    BoardSearch.make()
  end
  
  describe "associations" do
    it "should have a style" do
      BoardSearch.make_unsaved().should respond_to(:style)
    end
    
    it "should have a geocode" do
      BoardSearch.make_unsaved().should respond_to(:geocode)
    end
  end
  
  describe "validations" do
    it "should validate the presence of a geocode" do
      board_search = BoardSearch.make()
       
      board_search.geocode = nil
      board_search.should_not be_valid
    end
    
  end
  
  describe "methods" do
    it "should respond to an execute method" do
      board_search = BoardSearch.make()
      board_search.should respond_to(:execute)
    end
    
    it "execute should return an array" do
      board_search = BoardSearch.make()
      results = board_search.execute
      results.class.should ==  Array.new.class
    end
    
    it "execute should filter results based on geocode" do
      board1 = Board.make(:geocodable)
      board2 = Board.make(:geocodable)
      board2.location = board1.location
      board2.save
      board_search = BoardSearch.make(:geocode=>board1.location.geocode)
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_true
      #change location
      board2.location = Location.make(:geocodable2)
      # make sure you save the new state away into the db.
      board2.save 
      result = board_search.execute
      result.include?(board1).should be_true
      result.include?(board2).should be_false 
    end

    it "execute should filter results based on style" do
      board1 = Board.make(:geocodable)
      board2 = Board.make(:geocodable)
      board_search = BoardSearch.make(:geocode=>board1.location.geocode,:style=>nil)
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
