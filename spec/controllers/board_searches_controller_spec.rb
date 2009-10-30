require File.dirname(__FILE__) + '/../spec_helper'
 
describe BoardSearchesController do
  describe "anonymous user" do
    
    describe "new action" do
      it "should assign a new BoardSearch model for the view " do
        get "new"
        assigns[:board_search].should be_new_record
      end
    end
    
    describe "create action" do
      it "should save the board search" do
        BoardSearch.any_instance.expects(:save)
        post "create"
      end
      
      it "should pass parameters to board search" do
        post "create", :board_search =>{:board_type =>"longboard"}
        assigns[:board_search].board_type.should == 'longboard'
      end
      
      it "should redirect to show action on successful save" do
        BoardSearch.any_instance.stubs(:valid?).returns(true)
        post "create"
        response.should redirect_to board_search_path(assigns[:board_search])
      end
      
      it "should render the new view on an unsuccessful save" do
        BoardSearch.any_instance.stubs(:valid?).returns(false)
        post "create"
        response.should render_template('new')
      end
    end
    
    describe "show action" do
      before(:each) do
        @board_search = BoardSearch.make()
        get "show", :id=>@board_search.id
      end
      it "should find the board search in the database" do
        assigns[:board_search].should_not be_nil
      end
      
      it "should assign a non-nil array of boards for the view" do
        assigns[:found_boards].should_not be_nil
      end
      
      it "should render the show view" do
        response.should render_template('show')
      end
    end
  end
end
