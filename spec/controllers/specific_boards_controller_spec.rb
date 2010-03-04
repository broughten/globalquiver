require 'spec_helper'

describe SpecificBoardsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views
#
#  #Delete these examples and add some real ones
  it "should use SpecificBoardsController" do
    controller.should be_an_instance_of(SpecificBoardsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

    describe "edit specific board" do
      before(:each) do
        @user.board_locations << BoardLocation.make()
        @board = SpecificBoard.make()
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

    describe "PUT /boards (aka update board) update specific board" do
      before(:each) do
        @temp_board = SpecificBoard.make(:creator => @user)
      end
      it "should try to update the attributes of the board" do
        SpecificBoard.any_instance.expects(:update_attributes)
        post 'update', :id=>@temp_board.id
      end
      it "should redirect to the show view with a flash message after successful update" do
        SpecificBoard.any_instance.stubs(:valid?).returns(true)
        post 'update', :id=>@temp_board.id
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end
      it "should not allow you to deactivate a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        SpecificBoard.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', {:id=>@temp_board.id, :board => {:inactive => true}}
        flash[:error].should_not be_nil
        response.should redirect_to(root_path)
      end

      it "should allow you to change blackout dates on a board with reservations in the future" do
        @request.env['HTTP_REFERER'] = root_path
        SpecificBoard.any_instance.stubs(:has_future_reservations).returns(true)
        post 'update', {:id=>@temp_board.id, :board => {:black_out_dates_attributes => [{:id => "", :date => 3.days.from_now.strftime('%m/%d/%Y')}]}}
        flash[:error].should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(board_path(@temp_board))
      end

      it "should add the blackout dates that you select to the board" do
        post 'update', {:id=>@temp_board.id, :specific_board => {:black_out_dates_attributes => [{:id => "", :date => 3.days.from_now.strftime('%m/%d/%Y')}]}}
        assigns[:board].black_out_dates.first.date.should == 3.days.from_now.to_date
      end

      it "should render the edit view if a field doesn't validate" do
        SpecificBoard.any_instance.stubs(:valid?).returns(false)
        post 'update', {:id=>@temp_board.id, :board => {:daily_fee => "wrong"}}
        response.should render_template("specific_boards/edit")
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

        board = SpecificBoard.make(:creator => @user,
                           :length_feet => 6,
                           :length_inches => 3,
                           :width_inches => 20,
                           :width_fraction => 0.5,
                           :thickness_inches => 3,
                           :thickness_fraction => 0
                          )

        post 'update', { :id=>board.id,
                          :specific_board => {
                            :length_feet => "5",
                            :length_inches => "11",
                            :width_inches => "17",
                            :width_fraction => "0",
                            :thickness_inches => "2",
                            :thickness_fraction => "0.5"
                          }
        }



        assigns[:board].length_feet.should == 5
        assigns[:board].length_inches.should == 11
        assigns[:board].width_inches.should == 17
        assigns[:board].width_fraction.should == '0.0'
        assigns[:board].thickness_inches.should == 2
        assigns[:board].thickness_fraction.should == '0.5'


      end
    end
  end
end
