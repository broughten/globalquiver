require 'spec_helper'

describe ReservationsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use ReservationsController" do
    controller.should be_an_instance_of(ReservationsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

    describe "new reservation" do
      before(:each) do
        @temp_board = Board.make()
      end

      it "should attempt to find the board in question" do
        Board.expects(:find).returns(@temp_board)
        get 'new', :id=>@temp_board.id
        assigns[:board].should == @temp_board
      end
    end
  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions
  end

end
