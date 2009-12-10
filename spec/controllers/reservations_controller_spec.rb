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

    describe "GET /boards/:id/reservations/new" do
      before(:each) do
        @temp_board = Board.make()
      end
      
      it "should redirect to the root pate with a flash error if the owner of the board tries to create a new reservation" do
        @temp_board = Board.make(:creator=>@user)
        get 'new', :board_id=>@temp_board.id
        response.should redirect_to(root_path)
        flash[:error].should_not be_nil
      end

      it "should attempt to find the board in question and assign to to the reservation" do
        Board.expects(:find).returns(@temp_board)
        get 'new', :board_id=>@temp_board.id
        assigns[:reservation].board.should_not be_nil
      end
      
      it "should assign a new reservation" do
        get 'new', :board_id=>@temp_board.id
        assigns[:reservation].should be_new_record
      end
      
      it "should render the new view" do
        get 'new', :board_id=>@temp_board.id
        response.should render_template('new')
      end
    end
    
    describe "POST /boards/:id/reservations (aka create reservation for board)" do
      before(:each) do
        @test_board = Board.make()
      end
      it "should pass parameters to new reservation"
      
      it "should find the existing board and assign it to the reservation" do
        post "create", :board_id=>@test_board.id
        assigns[:reservation].board.should == @test_board
      end
      
      it "should render the show template with a flash message on successful save" do
        Reservation.any_instance.stubs(:valid?).returns(true)
        post "create", :board_id=>@test_board.id
        assigns[:reservation].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(reservation_path)
      end
      
      describe "save failure" do
        before(:each) do
          Board.any_instance.stubs(:valid?).returns(false)
        end
        it "should render new template with a flash error message" do
          post 'create'
          assigns[:reservation].should be_new_record
          flash[:error].should_not be_nil
          response.should render_template('new')
        end
      end
    end
  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :create
  end

end
