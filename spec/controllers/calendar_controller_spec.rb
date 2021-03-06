require 'spec_helper'

describe CalendarController do
	integrate_views
  
  it "should use CalendarController" do
    controller.should be_an_instance_of(CalendarController)
  end
  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    describe "GET /shop_calendar" do
    it "should assign parameters for month and year to instance variables" do
      get 'shop_calendar', :month=>2, :year=>2009
      assigns[:month].should == 2
      assigns[:year].should == 2009
    end

    it "should assign shown month" do
      get 'shop_calendar', :month=>2, :year=>2009
      assigns[:shown_month].should == Date.civil(2009, 2)
    end

    it "should assign reservations" do
      board = Board.make(:creator => @user)
      in_reservation1 = Reservation.make(:board => board, :reserved_dates => [
        UnavailableDate.make(:date => 3.days.from_now)
      ])
      in_reservation2 = Reservation.make(:board => board, :reserved_dates => [
        UnavailableDate.make(:date => 5.days.from_now),
        UnavailableDate.make(:date => 7.days.from_now),
        UnavailableDate.make(:date => 9.days.from_now)
      ])
      out_reservation = Reservation.make(:board => board, :reserved_dates => [
        UnavailableDate.make(:date => 35.days.from_now),
        UnavailableDate.make(:date => 37.days.from_now),
        UnavailableDate.make(:date => 39.days.from_now)
      ])

      get 'shop_calendar', :month=>Date.today.month, :year=>Date.today.year

      assigns[:reservations].should == [in_reservation1, in_reservation2]

    end

    it "should assign reservation strips" do
      # The number of nils must equal the number of days in the month here.
       Reservation.expects(:create_reservation_strips).returns([
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      ])
      get 'shop_calendar', :month=>2, :year=>2009
      assigns[:reservation_strips].should_not be_nil
    end

    it "should render the shop_calendar view" do
      get 'shop_calendar', :month=>2, :year=>2009
      response.should render_template("shop_calendar")
    end
  end
    describe "GET /trip_calendar" do
      it "should assign parameters for month and year to instance variables" do
        get 'trip_calendar', :month=>2, :year=>2009
        assigns[:month].should == 2
        assigns[:year].should == 2009
      end

      it "should assign shown month" do
        get 'trip_calendar', :month=>2, :year=>2009
        assigns[:shown_month].should == Date.civil(2009, 2)
      end

      it "should assign reservations" do
        in_reservation1 = Reservation.make(:creator => @user, :reserved_dates => [
          UnavailableDate.make(:date => 3.days.from_now)
        ])
        in_reservation2 = Reservation.make(:creator => @user, :reserved_dates => [
          UnavailableDate.make(:date => 5.days.from_now),
          UnavailableDate.make(:date => 7.days.from_now),
          UnavailableDate.make(:date => 9.days.from_now)
        ])
        out_reservation = Reservation.make(:creator => @user, :reserved_dates => [
          UnavailableDate.make(:date => 35.days.from_now),
          UnavailableDate.make(:date => 37.days.from_now),
          UnavailableDate.make(:date => 39.days.from_now)
        ])

        get 'trip_calendar', :month=>Date.today.month, :year=>Date.today.year

        assigns[:reservations].should == [in_reservation1, in_reservation2]

      end

      it "should assign reservation strips" do
        # The number of nils must equal the number of days in the month here.
         Reservation.expects(:create_reservation_strips).returns([
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ])
        get 'trip_calendar', :month=>2, :year=>2009
        assigns[:reservation_strips].should_not be_nil
      end

      it "should render the trip_calendar view" do
        get 'trip_calendar', :month=>2, :year=>2009
        response.should render_template("trip_calendar")
      end
  end

  end
end
