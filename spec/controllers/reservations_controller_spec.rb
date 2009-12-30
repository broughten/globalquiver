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
      
      it "should redirect back with a flash error if the owner of the board tries to create a new reservation" do
        @request.env['HTTP_REFERER'] = new_board_search_path
        @temp_board = Board.make(:creator=>@user)
        get 'new', :board_id=>@temp_board.id
        response.should redirect_to(new_board_search_path)
        flash[:error].should_not be_nil
      end

      it "should redirect back with a flash error if the user tries to create a reservation on an inactive board" do
        @request.env['HTTP_REFERER'] = new_board_search_path
        @temp_board = Board.make(:creator=>@user, :inactive=>true)
        get 'new', :board_id=>@temp_board.id
        response.should redirect_to(new_board_search_path)
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
      
      it "should find the existing board and assign it to the reservation" do
        post "create", :board_id=>@test_board.id
        assigns[:reservation].board.should == @test_board
      end
      
      it "should render the show template with a flash message and an email on successful save" do
        Reservation.any_instance.stubs(:valid?).returns(true)
        UserMailer.expects(:deliver_board_renter_reservation_details)
        post "create", :board_id=>@test_board.id
        assigns[:reservation].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(reservation_path(assigns[:reservation]))
      end
      
      describe "save failure" do
        before(:each) do
          Board.any_instance.stubs(:valid?).returns(false)
        end
        it "should render new template with a flash error message" do
          post 'create', :board_id=>@test_board.id
          assigns[:reservation].should be_new_record
          flash[:error].should_not be_nil
          response.should render_template('new')
        end
      end
    end # of create reservation
    
    describe "Get /reservations/:id (aka show reservation)" do
      before(:each) do
        @reservation = Reservation.make()
      end
      
      it "should attempt to find the reservation in question" do
        Reservation.expects(:find).returns(@reservation)
        get 'show', :id=>@reservation.id
        assigns[:reservation].should == @reservation
      end
      
      it "should render the show view" do
        get 'show', :id=>@reservation.id
        response.should render_template("show")
      end
    end # of show reservation
  end # of authenticated user

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :create, :show
  end

end
