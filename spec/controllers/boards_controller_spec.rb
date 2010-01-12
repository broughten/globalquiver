require 'spec_helper'

describe BoardsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

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
        
        it "should create Board::MAX_PICTURES for the new board" do
          get "new"
          assigns[:board].images.length.should == Board::MAX_IMAGES
        end
      end
      
      describe "user without locations" do
        it "should redirect to the new location path if the logged in user doesn't have any locations" do
          get "new"
          response.should redirect_to new_board_location_path
        end
      end
    end
    
    describe "POST /boards (aka create board)" do
      it "should pass parameters to new board" do
        post "create", :board =>{:maker =>"Test Maker"}
        assigns[:board].maker.should == "Test Maker"
      end
      it "should redirect to root path with a flash message on successful save" do
        Board.any_instance.stubs(:valid?).returns(true)
        post 'create'
        assigns[:board].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(root_path)
      end
      
      describe "save failure" do
        before(:each) do
          Board.any_instance.stubs(:valid?).returns(false)
        end
        it "should render new template without a flash message" do
          post 'create'
          assigns[:board].should be_new_record
          flash[:notice].should be_nil
          response.should render_template('new')
        end
        
        it "should make sure that board has at least Board::MAX_IMAGES created" do
          post 'create'
          assigns[:board].images.length.should == Board::MAX_IMAGES
        end
      end
    end
    
    
    describe "PUT /boards (aka update board)" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should try to update the attributes of the board" do
        Board.any_instance.expects(:update_attributes)
        post 'update', :id=>@temp_board.id
      end
      it "should redirect to the show view with a flash message after successful update" do
        Board.any_instance.stubs(:valid?).returns(true)
        post 'update', :id=>@temp_board.id
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end
      it "should not allow you to deactivate a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        Board.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', :id=>@temp_board.id
        flash[:error].should_not be_nil
        response.should redirect_to(root_path)
      end
    end
    
    
    describe "show board" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        get 'show', :id=>@temp_board.id
        assigns[:board].should == @temp_board
      end
      
      it "should render the show view" do
        get 'show', :id=>@temp_board.id
        response.should render_template("show")
      end
    end
  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :edit, :create, :update, :destroy, :select_reserved_dates
  end

end
