require 'spec_helper'
include UnavailableDatesHelper
describe UnavailableDatesHelper do 
  describe "json methods" do  
    describe "black_out_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        black_out_dates_json_for(@board).should eql("null")
      end

      it "should return a json list of blackout dates for this board created by users other than the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @someone_else)
   
        #reserved dates created by @me and @me is the current_user
        Reservation.make(:creator => @me, :board => @board, :reserved_dates => [
          UnavailableDate.make(:date => 3.days.from_now),
          UnavailableDate.make(:date => 5.days.from_now),
          UnavailableDate.make(:date => 7.days.from_now),
          UnavailableDate.make(:date => 9.days.from_now),
          UnavailableDate.make(:date => 11.days.from_now)
        ])
        #board owner's black out dates created by @someone_else (and @someone_else is not the current user)
        UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :parent => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :parent => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :parent => @board)
   
        ActiveSupport::JSON.decode(black_out_dates_json_for(@board)).length.should == 3
      end
    end
     
    describe "reserved_dates_json" do
      it "should return null if reserved_dates is blank" do
        @board = Board.make()
        reserved_dates_json_for(@board).should eql("null")
      end
   
      it "should return a json list of reserved dates for this board created by the current user" do
        @me = Surfer.make()
        @someone_else = Surfer.make()
        @yet_another_person = Surfer.make()
        self.stubs(:current_user).returns(@me)
        @board = Board.make(:creator => @someone_else)
   
        #reserved dates created by @me and @me is the current_user
        Reservation.make(:creator => @me, :board => @board, :reserved_dates => [
          UnavailableDate.make(:date => 3.days.from_now),
          UnavailableDate.make(:date => 5.days.from_now),
          UnavailableDate.make(:date => 7.days.from_now),
          UnavailableDate.make(:date => 9.days.from_now),
          UnavailableDate.make(:date => 11.days.from_now)
        ])
        #reserved dates created by @yet_another_person (and @yet_another_person is NOT the current user)
        UnavailableDate.make(:date => 4.days.from_now, :creator => @yet_another_person, :parent => @board)
        UnavailableDate.make(:date => 6.days.from_now, :creator => @yet_another_person, :parent => @board)
        UnavailableDate.make(:date => 8.days.from_now, :creator => @yet_another_person, :parent => @board)
        UnavailableDate.make(:date => 10.days.from_now, :creator => @yet_another_person, :parent => @board)
   
        ActiveSupport::JSON.decode(reserved_dates_json_for(@board)).length.should == 5
      end
    end
  end
end
