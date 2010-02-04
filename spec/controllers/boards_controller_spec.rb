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

    describe "edit board" do
      before(:each) do
        @user.board_locations << BoardLocation.make()
        @board = Board.make()
      end

      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@board)
        get 'edit', :id=>@board.id
        assigns[:board].should == @board
      end
      it "should assign needed variables for view" do
        get "edit", :id => @board.id
        assigns[:existing_locations].should == @user.board_locations
      end

      it "should render the edit view" do
        get "edit", :id => @board.id
        response.should render_template "edit"
      end

      it "should create Board::MAX_PICTURES for the new board" do
        get "new"
        assigns[:board].images.length.should == Board::MAX_IMAGES
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
        @temp_board = Board.make(:creator => @user)
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
        post 'update', {:id=>@temp_board.id, :board => {:inactive => true}}
        flash[:error].should_not be_nil
        response.should redirect_to(root_path)
      end

      it "should allow you to change blackout dates on a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        Board.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', {:id=>@temp_board.id, :board => {:black_out_dates_attributes => [{:id => "", :date => 3.days.from_now.strftime('%m/%d/%Y')}]}}
        flash[:error].should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end

      it "should render the edit view if a field doesn't validate" do
        Board.any_instance.stubs(:valid?).returns(false)
        post 'update', {:id=>@temp_board.id, :board => {:daily_fee => "wrong"}}
        response.should render_template(:edit)
      end

      it "should not allow you to deactivate a board you don't own" do
        @request.env['HTTP_REFERER'] = root_path
        user = User.make
        @temp_board.creator = user
        @temp_board.save
        post 'update', :id=>@temp_board.id
        flash[:error].should == 'Only the board owner can activate and deactivate boards.'
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

    describe "add comment to board" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        post 'new_comment', :id => @temp_board.id, :comment => {:body => "comment"}
        assigns[:board].should == @temp_board
      end

      it "should attempt to build a new comment" do
        post 'new_comment', :id => @temp_board.id, :comment => {:body => "comment"}
        assigns[:comment].commentable_id.should == @temp_board.id
      end

      it "should attempt to save the comment" do
        Comment.any_instance.expects(:save)
        xhr :post, 'new_comment', {:id => @temp_board.id, :comment => {:body => "comment"}}
      end

      it "should send an email to the baord owner if the commentor and the board owner are not the same person" do
        UserMailer.expects(:deliver_comment_notification)
        other_user = User.make()
        board = Board.make(:creator => other_user)
        xhr :post, 'new_comment', {:id => board.id, :comment => {:body => "comment"}}

      end

      it "should render an alert if the comment fails to save" do
        Comment.any_instance.stubs(:valid?).returns(false)
        xhr :post, 'new_comment', {:id => @temp_board.id, :comment => {:body => "comment"}}
        response.should contain("alert('Ooops! Something went wrong. Please refresh this page and try again.');")
      end
    end
    describe "new location for board" do
      before(:each) do
        @temp_board = Board.make()
      end
      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        post 'new_location_for_board', :id => @temp_board.id
        assigns[:board].should == @temp_board
      end

      it "should initialize some instance variables" do
        post 'new_location_for_board', :id => @temp_board.id
        assigns[:board_location].should_not be_nil
        assigns[:existing_locations].should_not be_nil
        assigns[:map].should_not be_nil
      end
    end
  end

  describe "anonymous user" do
    it "new action should require authentication" do

      get :new
      response.should redirect_to(login_path)
    end
    it "new action should require authentication" do

      get :edit, :id => "1"
      response.should redirect_to(login_path)
    end
    it "create action should require authentication" do

      post :create, :id => "1"
      response.should redirect_to(login_path)
    end
    it "update action should require authentication" do

      put :update, :id => "1"
      response.should redirect_to(login_path)
    end
    it "destroy action should require authentication" do

      put :destroy, :id => "1"
      response.should redirect_to(login_path)
    end

    it "new_comment action should require authentication" do

      post :new_comment, :id => "1", :comment => {:body => "comment"}
      response.should redirect_to(login_path)
    end

  end

end
