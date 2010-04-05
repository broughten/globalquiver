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
        @test_board = SpecificBoard.make()
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
        @reservation = Reservation.make(:board => Board.make(:location => BoardLocation.make(:santa_barbara_ca)))
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

    describe "DELETE /reservations (aka delete reservation)" do

      it "should try to find the reservation in question" do
        @temp_reservation = Reservation.make()
        @request.env['HTTP_REFERER'] = reservation_path(@temp_reservation)
        Reservation.expects(:find).returns(@temp_reservation)
        post 'destroy', :id=>@temp_reservation.id
      end
      it "should try to delete the reservation" do
        @temp_reservation = Reservation.make(:creator => @user)
        @request.env['HTTP_REFERER'] = reservation_path(@temp_reservation)
        Reservation.any_instance.expects(:destroy)
        post 'destroy', :id=>@temp_reservation.id
      end
      it "should redirect back upon successful cancelation" do
        @temp_reservation = Reservation.make(:creator => @user)
        @request.env['HTTP_REFERER'] = reservation_path(@temp_reservation)
        post 'destroy', :id=>@temp_reservation.id
        response.should redirect_to root_path
      end

      it "should render a flash message and send an email on successful cancelation" do
        @temp_reservation = Reservation.make(:creator => @user)
        UserMailer.expects(:deliver_reservation_cancelation_details)
        post "destroy", :id=>@temp_reservation.id
        assigns[:reservation].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(root_path)
      end

      it "should not allow anyone other than the reservation creator to cancel the reservation" do
        someone_else = User.make()
        @temp_reservation = Reservation.make(:creator => someone_else)
        @request.env['HTTP_REFERER'] = reservation_path(@temp_reservation)
        post 'destroy', :id=>@temp_reservation.id
        flash[:error].should == "You can't cancel someone else's reservation"
        response.should redirect_to reservation_path(@temp_reservation)
      end
    end # of delete reservation
  end # of authenticated user

  describe "anonymous user" do

    it "new action should require authentication" do

      get :new, :board_id => "1"
      response.should redirect_to(login_path)
    end
    it "create action should require authentication" do

      post :create, :board_id => "1"
      response.should redirect_to(login_path)
    end
    it "show action should require authentication" do

      get :show, :id => "1"
      response.should redirect_to(login_path)
    end

  end

end
