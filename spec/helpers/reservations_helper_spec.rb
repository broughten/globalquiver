require 'spec_helper'
include ReservationsHelper
describe ReservationsHelper do
  describe "days_until_next_reservation" do
    before(:each) do
      @me = Surfer.make()
      @someone_else = Surfer.make()
      
      self.stubs(:current_user).returns(@me)
    end

     it "should give an accurate count of the number of days until the next reservation for a board renter" do
       board = Board.make(:creator => @someone_else)
       #reservations created by @me
       Reservation.make(:creator => @me, :board => board, :reservation_dates => [
         UnavailableDate.make(:date => 3.days.from_now),
         UnavailableDate.make(:date => 5.days.from_now),
         UnavailableDate.make(:date => 7.days.from_now),
         UnavailableDate.make(:date => 9.days.from_now),
         UnavailableDate.make(:date => 11.days.from_now)
       ])
   
       #blackout dates created by @someone_else
       UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :parent => @board)
       UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :parent => @board)
       UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :parent => @board)
       UnavailableDate.make(:date => 10.days.from_now, :creator => @someone_else, :parent => @board)
   
       days_until_next_reservation.should eql(3.days.from_now.to_date - Date.today)
   
     end
   
     it "should give an accurate count of the number of days until the next reservation for a board owner" do
       board = Board.make(:creator => @me)
       #reservations created by @me
       Reservation.make(:creator => @me, :board => board, :reservation_dates => [
         UnavailableDate.make(:date => 5.days.from_now),
         UnavailableDate.make(:date => 7.days.from_now),
         UnavailableDate.make(:date => 9.days.from_now),
         UnavailableDate.make(:date => 11.days.from_now)
       ])

       #reservations created by @someone_else
       Reservation.make(:creator => @someone_else, :board => board, :reservation_dates => [
         UnavailableDate.make(:date => 10.days.from_now),
         UnavailableDate.make(:date => 8.days.from_now),
         UnavailableDate.make(:date => 6.days.from_now),
         UnavailableDate.make(:date => 4.days.from_now)
       ])
       days_until_next_reservation.should eql(4.days.from_now.to_date - Date.today)
     end
   
     it "should return -1 if there are no upcoming reservations" do
       @board = Board.make(:creator => @me)
       days_until_next_reservation.should eql(-1)
     end
   
   end
end
