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
      #my reservations
      UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

      #board owner's black out dates
      UnavailableDate.make(:date => 4.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 6.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 8.days.from_now, :creator => @someone_else, :board => @board)
      UnavailableDate.make(:date => 10.days.from_now, :creator => @someone_else, :board => @board)

      days_until_next_reservation.should eql(3.days.from_now.to_date - Date.today)

    end

    it "should give an accurate count of the number of days until the next reservation for a board owner" do
      @board = Board.make(:creator => @me)
      #my reservations
      UnavailableDate.make(:date => 3.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 5.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 7.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 9.days.from_now, :creator => @me, :board => @board)
      UnavailableDate.make(:date => 11.days.from_now, :creator => @me, :board => @board)

      #board owner's black out dates
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
end
