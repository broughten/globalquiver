require 'spec_helper'
include UnavailableDatesHelper
describe UnavailableDatesHelper do
  describe "days_until_next_reservation" do
    before(:each) do
      @me = Surfer.make()
      @someone_else = Surfer.make()
      
      self.stubs(:current_user).returns(@me)
    end

    it "should give an accurate count of the number of days until the next reservation for a board renter" do
      @board = Board.make(:creator => @someone_else)
      #reservations created by @me
      UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

      #blackout dates created by @someone_else
      UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 10.days.from_now, :creator => @someone_else, :board => @board)

      days_until_next_reservation.should eql(3.days.from_now.to_date - Date.today)

    end

    it "should give an accurate count of the number of days until the next reservation for a board owner" do
      @board = Board.make(:creator => @me)
      #black out dates created by @me
      UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

      #reservations created by @someone_else
      UnavailableDate.make(:date => 10.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :board => @board)

      days_until_next_reservation.should eql(4.days.from_now.to_date - Date.today)
    end

    it "should return -1 if there are no upcoming reservations" do
      @board = Board.make(:creator => @me)
      days_until_next_reservation.should eql(-1)
    end

  end

  describe "json methods" do


    describe "taken_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        taken_dates_json.should eql("null")
      end

      it "should return a json list of reserved dates for this board created by users other than the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @someone_else)

        #reserved dates created by @me
        UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

        #reserved dates created by @yet_another_person
        UnavailableDate.make(:date => 4.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 10.days.from_now, :creator => @yet_another_person, :board => @board)

        ActiveSupport::JSON.decode(taken_dates_json).length.should == 4

      end
    end

    describe "black_out_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        black_out_dates_json.should eql("null")
      end

      it "should return a json list of blackout dates for this board created by users other than the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @someone_else)

        #reserved dates created by @me
        UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

        #board owner's black out dates created by @someone_else (and @someone_else is not the current user)
        UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :board => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :board => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :board => @board)

        ActiveSupport::JSON.decode(black_out_dates_json).length.should == 3
      end
    end

    describe "owner_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        owner_dates_json.should eql("null")
      end

      it "should return a json list of blackout dates for this board created by the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @me)

        #board owner's black out dates created by @me (and @me is the current user)
        UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
        
        #reserved dates created by @someone_else
        UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :board => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :board => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :board => @board)

        ActiveSupport::JSON.decode(owner_dates_json).length.should == 2
      end
    end

    describe "reserved_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        reserved_dates_json.should eql("null")
      end

      it "should return a json list of reserved dates for this board created by the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @someone_else)

        #reserved dates created by @me and @me is the current_user
        UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
        UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

        #reserved dates created by @yet_another_person (and @yet_another_person is NOT the current user)
        UnavailableDate.make(:date => 4.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @yet_another_person, :board => @board)
        UnavailableDate.make(:date => 10.days.from_now, :creator => @yet_another_person, :board => @board)

        ActiveSupport::JSON.decode(reserved_dates_json).length.should == 5
      end
    end
  end
end
