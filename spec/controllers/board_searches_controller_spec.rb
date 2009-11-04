require File.dirname(__FILE__) + '/../spec_helper'
 
describe BoardSearchesController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views
  
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
        @board_search = make_board_search
        BoardSearch.any_instance.stubs(:execute).returns(Array.new)
      end
      
      it "should find the saved board search" do
        get "show", :id=>@board_search.id
        assigns[:board_search].should_not be_nil
      end
  
      it "should assign a non-nil array of boards for the view" do
        get "show", :id=>@board_search.id
        assigns[:found_boards].should_not be_nil
      end
      
      it "should render the show view" do
        get "show", :id=>@board_search.id
        response.should render_template('show')
      end
      
      it "should perform the search" do
        BoardSearch.any_instance.expects(:execute).returns(Array.new)
        get "show", :id=>@board_search.id
      end
    end
  end
end
