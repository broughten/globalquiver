require 'spec_helper'

describe BoardsController do
  #integrate_views

  #Delete these examples and add some real ones
  it "should use BoardsController" do
    controller.should be_an_instance_of(BoardsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    
    describe "GET /boards/new" do
      describe "user with locations" do
        before(:each) do
          @user.locations << Location.make()
        end
        it "should assign needed variables for view" do
          get "new"
          assigns[:board].should_not be_nil
          assigns[:existing_locations].should_not be_nil
        end
        
        it "should render the new view" do
          get "new"
          response.should render_template "new"
        end
      end
      
      describe "user without locations" do
        it "should redirect to the new location path if the logged in user doesn't have any locations" do
          get "new"
          response.should redirect_to new_location_path
        end
      end
    end
    
    describe "POST /boards (aka create board)" do
      it "should pass parameters to new board" do
        post "create", :board =>{:maker =>"Test Maker"}
        assigns[:board].maker.should == "Test Maker"
      end
      it "should redirect to overview path with a flash message on successful save" do
        Board.any_instance.stubs(:valid?).returns(true)
        post 'create'
        assigns[:board].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(overview_path)
      end

      it "should render new template without a flash message on unsuccessful save" do
        Board.any_instance.stubs(:valid?).returns(false)
        post 'create'
        assigns[:board].should be_new_record
        flash[:notice].should be_nil
        response.should render_template('new')
      end
    end
    
    describe "DELETE /boards (aka delete board)" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should try to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        post 'destroy', :id=>@temp_board.id
      end
      it "should try to delete the board" do
        Board.any_instance.expects(:destroy)
       post 'destroy', :id=>@temp_board.id
      end
      it "should redirect to the overview path" do
        post 'destroy', :id=>@temp_board.id
        response.should redirect_to overview_path
      end
    end
    
    describe "PUT /boards (aka update board)" do
      it "should have some specs so define them here" do
        
      end
    end
    
    describe "edit board" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should attempt to find the board in question and allow the view to use it" do
        Board.expects(:find).returns(@temp_board)
        post 'edit', :id=>@temp_board.id
        assigns[:board].should == @temp_board
      end
      
      it "should render the edit view" do
        post 'edit', :id=>@temp_board.id
        response.should render_template("edit")
      end
    end
    
    describe "show board" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        post 'show', :id=>@temp_board.id
        assigns[:board].should == @temp_board
      end
      
      it "should render the show view" do
        post 'show', :id=>@temp_board.id
        response.should render_template("show")
      end
    end
  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :edit, :create, :update, :destroy
  end

end
