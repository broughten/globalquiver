require 'spec_helper'

describe GenericBoardsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views
#
#  #Delete these examples and add some real ones
  it "should use GenericBoardsController" do
    controller.should be_an_instance_of(GenericBoardsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

    describe "edit generic board" do
      before(:each) do
        @user.board_locations << BoardLocation.make()
        @board = GenericBoard.make()
      end

      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@board)
        get :edit, :id=>@board.id
        assigns[:board].should == @board
      end
      it "should assign needed variables for view" do
        get :edit, :id => @board.id
        assigns[:existing_locations].should == @user.board_locations
      end

      it "should render the edit view" do
        get :edit, :id => @board.id
        response.should render_template "edit"
      end

      it "should create Board::MAX_PICTURES for the new board" do
        get :edit, :id => @board.id
        assigns[:board].images.length.should == Board::MAX_IMAGES
      end
    end

    describe "PUT /boards (aka update board) update generic board" do
      before(:each) do
        @temp_board = GenericBoard.make(:creator => @user)
      end
      it "should try to update the attributes of the board" do
        GenericBoard.any_instance.expects(:update_attributes)
        post 'update', :id=>@temp_board.id
      end
      it "should redirect to the show view with a flash message after successful update" do
        GenericBoard.any_instance.stubs(:valid?).returns(true)
        post 'update', :id=>@temp_board.id
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end
      it "should not allow you to deactivate a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        GenericBoard.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', {:id=>@temp_board.id, :board => {:inactive => true}}
        flash[:error].should_not be_nil
        response.should redirect_to(root_path)
      end

      it "should allow you to change blackout dates on a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        GenericBoard.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', {:id=>@temp_board.id, :board => {:black_out_dates_attributes => [{:id => "", :date => 3.days.from_now.strftime('%m/%d/%Y')}]}}
        flash[:error].should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end

      it "should render the edit view if a field doesn't validate" do
        GenericBoard.any_instance.stubs(:valid?).returns(false)
        post 'update', {:id=>@temp_board.id, :board => {:daily_fee => "wrong"}}
        response.should render_template("generic_boards/edit")
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

      it "should update measurements properly" do

        board = GenericBoard.make(:creator => @user,
                           :upper_length_feet => 6,
                           :upper_length_inches => 3,
                           :lower_length_feet => 6,
                           :lower_length_inches => 0
                          )

        post 'update', { :id=>board.id,
                          :generic_board => {
                           :upper_length_feet => 6,
                           :upper_length_inches => 6,
                           :lower_length_feet => 5,
                           :lower_length_inches => 11
                          }
        }



        assigns[:board].upper_length_feet.should == 6
        assigns[:board].upper_length_inches.should == 6
        assigns[:board].lower_length_feet.should == 5
        assigns[:board].lower_length_inches.should == 11


      end
    end

  end
end
