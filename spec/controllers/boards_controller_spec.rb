require 'spec_helper'

describe BoardsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views
#
#  #Delete these examples and add some real ones
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
          assigns[:board].should be_a(SpecificBoard)
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


    describe "POST /boards (aka create specific board)" do
      it "should pass parameters to new board" do
        post "create", :board =>{:maker =>"Test Maker"}, :board_type => "SpecificBoard"
        assigns[:board].maker.should == "Test Maker"
      end
      it "should redirect to root path with a flash message on successful save" do
        SpecificBoard.any_instance.stubs(:valid?).returns(true)
        post 'create', :board_type => 'SpecificBoard'
        assigns[:board].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(root_path)
      end

      describe "save failure" do
        before(:each) do
          SpecificBoard.any_instance.stubs(:valid?).returns(false)
        end
        it "should render new template without a flash message" do
          post 'create', :board_type => "SpecificBoard"
          assigns[:board].should be_new_record
          flash[:notice].should be_nil
          response.should render_template('boards/new')
        end

        it "should make sure that board has at least Board::MAX_IMAGES created" do
          post 'create', :board_type => "SpecificBoard"
          assigns[:board].images.length.should == Board::MAX_IMAGES
        end
      end
    end

    describe "POST /boards (aka create generic board)" do
      it "should pass parameters to new board" do
        post "create", :board =>{:maker =>"Test Maker"}, :board_type => "GenericBoard"
        assigns[:board].maker.should == "Test Maker"
      end
      it "should redirect to root path with a flash message on successful save" do
        GenericBoard.any_instance.stubs(:valid?).returns(true)
        post 'create', :board_type => 'GenericBoard'
        assigns[:board].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(root_path)
      end

      describe "save failure" do
        before(:each) do
          GenericBoard.any_instance.stubs(:valid?).returns(false)
        end
        it "should render new template without a flash message" do
          post 'create', :board_type => "GenericBoard"
          assigns[:board].should be_new_record
          flash[:notice].should be_nil
          response.should render_template('boards/new')
        end

        it "should make sure that board has at least Board::MAX_IMAGES created" do
          post 'create', :board_type => "GenericBoard"
          assigns[:board].images.length.should == Board::MAX_IMAGES
        end

        it "should create a generic board" do
          post 'create', :board_type => "GenericBoard"
          assigns[:board].should be_a GenericBoard
        end
      end
    end

    describe "show specific board" do
      before(:each) do
        @temp_board = SpecificBoard.make()
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
