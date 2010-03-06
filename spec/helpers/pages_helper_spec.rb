require 'spec_helper'
include PagesHelper
describe PagesHelper do
  describe "most_popular_board" do
    before(:each) do
      @less_popular_board = SpecificBoard.make(:images => [Image.make()])
      @more_popular_board = SpecificBoard.make(:images => [Image.make()])
      @board_without_photos = SpecificBoard.make()
      @inactive_board = Board.make()
      @date = Date.today
    end

    it "should return the active board that has pictures and the most reserved dates" do
      #less popular board has 3 reserved dates across 2 reservations
      Reservation.make(:board => @less_popular_board) do |reservation|
        2.times do
          reservation.reserved_dates.make(:date =>@date)
          @date += 1
        end
      end
      Reservation.make(:board => @less_popular_board, :reserved_dates => [UnavailableDate.make(:date =>@date)])
      @date += 1
      #more popular board has 4 reserved dates on just 1 reservation
      Reservation.make(:board => @more_popular_board) do |reservation|
        4.times do
          reservation.reserved_dates.make(:date =>@date)
          @date += 1
        end
      end

      #board without photos has 10 reserved dates on 3 reservations
      Reservation.make(:board => @board_without_photos) do |reservation|
        4.times do
          reservation.reserved_dates.make(:date =>@date)
          @date += 1
        end
      end
      Reservation.make(:board => @board_without_photos, :reserved_dates => [UnavailableDate.make(:date =>@date)])
      @date += 1
      Reservation.make(:board => @board_without_photos) do |reservation|
        5.times do
          reservation.reserved_dates.make(:date =>@date)
          @date += 1
        end
      end

      #inactive board has 5 reserved dates on just 1 reservation
      Reservation.make(:board => @inactive_board) do |reservation|
        5.times do
          reservation.reserved_dates.make(:date =>@date)
          @date += 1
        end
      end
      @inactive_board.inactive = true
      @inactive_board.save

      most_popular_board.should == @more_popular_board

    end
  end

  describe "most_recent_shop" do
    it "should return the most recently created shop" do

      newest_shop = Shop.make(:created_at => Time.now)
      oldest_shop = Shop.make(:created_at => 4.days.ago)
      Shop.make(:created_at => 3.days.ago)
      Shop.make(:created_at => 2.days.ago)
      Shop.make(:created_at => 1.days.ago)

      most_recent_shop.should == newest_shop

    end
  end
end
