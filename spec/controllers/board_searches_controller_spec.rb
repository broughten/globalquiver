require File.dirname(__FILE__) + '/../spec_helper'
 
describe BoardSearchesController do
  describe "anonymous user" do
    
    describe "new action" do
      it "should assign a new BoardSearch model for the view " do
        get "new"
        assigns[:board_search].should be_new_record
      end
      it "should assign a collection of geocodes for the view " do
        get "new"
        assigns[:geocodes].should_not be_nil
      end
    end
    
    describe "create action" do
      it "should save the board search" do
        BoardSearch.any_instance.expects(:save)
        post "create"
      end
      
      it "should pass parameters to board search" do
        post "create", :board_search =>{:geocode_id =>1}
        assigns[:board_search].geocode_id.should == 1
      end
      
      it "should redirect to show action on successful save" do
        BoardSearch.any_instance.stubs(:valid?).returns(true)
        post "create"
        response.should redirect_to board_search_path(assigns[:board_search])
      end
      
      it "should render the new view with some geocodes to display on an unsuccessful save" do
        BoardSearch.any_instance.stubs(:valid?).returns(false)
        post "create"
        assigns[:geocodes].should_not be_nil
        response.should render_template('new')
      end
    end
    
    describe "show action" do
      before(:each) do
        
      end
      
      it "should find the saved board search" do
        board_search = BoardSearch.make()
        get "show", :id=>board_search.id
        assigns[:board_search].should_not be_nil
      end
  
      it "should assign a non-nil array of boards for the view" do
        @board_search = BoardSearch.make()
        get "show", :id=>@board_search.id
        assigns[:found_boards].should_not be_nil
      end
      
      it "should render the show view" do
        @board_search = BoardSearch.make()
        get "show", :id=>@board_search.id
        response.should render_template('show')
      end
      
      it "should filter boards based on location geocode" do
        board1 = Board.make(:geocodable)
        board2 = Board.make(:geocodable)
        # now they have the same location
        board1.location = board2.location
        board_search = BoardSearch.make(:geocode=>board1.location.geocode)
        get "show", :id=>board_search.id
        assigns[:found_boards].include?(board1).should == true
        assigns[:found_boards].include?(board2).should == true
        
        #create a new location for the board
        board2.location = Location.make()
        get "show", :id=>board_search.id
        assigns[:found_boards].include?(board1).should == true
        assigns[:found_boards].include?(board2).should == false
        
      end
      
      it "should filter found boards by style name for non-empty style" do
        board1 = Board.make(:geocodable)
        board2 = Board.make(:geocodable)
        # same location so only style should be different
        board2.location = board1.location
        board_search = BoardSearch.make(:geocode=>board1.location.geocode, :style=>board1.style)
        get "show", :id=>board_search.id
        assigns[:found_boards].include?(board1).should == true
        assigns[:found_boards].include?(board2).should == false
      end
      
      it "should not filter found boards by style name for an empty style" do
        board1 = Board.make(:geocodable)
        board2 = Board.make(:geocodable)
        # same location so only style should be different
        board2.location = board1.location
        board_search = BoardSearch.make(:geocode=>board1.location.geocode, :style=>nil)
        get "show", :id=>board_search.id
        assigns[:found_boards].include?(board1).should == true
        assigns[:found_boards].include?(board2).should == true
      end
      
    end
  end
end
