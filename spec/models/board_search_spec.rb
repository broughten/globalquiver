require File.dirname(__FILE__) + '/../spec_helper'

describe BoardSearch do
  it "should be valid from the blueprint" do
    BoardSearch.make()
  end
  
  describe "associations" do
    it "should have a style" do
      BoardSearch.make_unsaved().should respond_to(:style)
      # confirm the db columns are right
      BoardSearch.make_unsaved().should respond_to(:style_id)
    end
    
    it "should have a location" do
      BoardSearch.make_unsaved().should respond_to(:location)
      # confirm the db columns are right
      BoardSearch.make_unsaved().should respond_to(:location_id)
    end
    
    it "should have a creator" do
      BoardSearch.make_unsaved().should respond_to(:creator)
      # confirm the db columns are right
      BoardSearch.make_unsaved().should respond_to(:creator_id)
    end
    
    it "should have an updater" do
      BoardSearch.make_unsaved().should respond_to(:updater)
      # confirm the db columns are right
      BoardSearch.make_unsaved().should respond_to(:updater_id)
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
      results.should be_instance_of(Array)
    end
    
    it "execute should return Board objects" do
      board1 = Board.make(:location=>BoardLocation.make(:santa_barbara_ca))
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location)
      result = board_search.execute
      result.first.should be_instance_of(Board)
    end
    
    it "execute should filter results based on location" do
      board1 = Board.make(:location=>BoardLocation.make(:santa_barbara_ca))
      # this board comes back with a location that is a mix of the BoardLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      board2 = Board.make(:location=>board1.location)
      board2.location = board1.location
      board2.save
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location)
      result = board_search.execute
      result.should include(board1)
      result.should include(board2)
      
      #change location
      board2.location = BoardLocation.make(:des_plaines_il)
      # make sure you save the new state away into the db.
      board2.save 
      result = board_search.execute
      #result.include?(board1).should be_true
      result.should include(board1)
      result.should_not include(board2)
    end

    it "execute should filter results based on style" do
      board1 = Board.make(:location=>BoardLocation.make(:santa_barbara_ca))
      # this board comes back with a location that is a mix of the BoardLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      board2 = Board.make(:location=>board1.location)
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location,:style=>nil)
      result = board_search.execute
      result.should include(board1)
      result.should include(board2)
      
      #change board_search style to something 
      board_search.style = board1.style
      result = board_search.execute
      result.should include(board1)
      result.should_not include(board2)
    end
    
    it "should not return boards that belong to the creator of the search" do
      user  = Surfer.make()
      board1 = Board.make(:location=>BoardLocation.make(:santa_barbara_ca), :creator=>user)
      board2 = Board.make(:location=>board1.location)
      search_location = SearchLocation.make(:locality=>board1.location.locality, :region=>board1.location.region, :country=>board1.location.country)
      board_search = BoardSearch.make(:location=>search_location,:creator=>user)
      result = board_search.execute
      result.should_not include(board1)
      result.should include(board2)
    end
  end  
end
