require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec_helper'

describe Board do

  it "should create a new instance from blueprint" do
    Board.make().should be_valid
  end
  
  describe "associations" do
    it "should have a style" do
      Board.make_unsaved().should respond_to(:style)
    end
    
    it "should have a location" do
      Board.make_unsaved().should respond_to(:location)
    end
    
    it "should have a creator" do
      Board.make_unsaved().should respond_to(:creator)
    end
    
    it "should have an updater" do
      Board.make_unsaved().should respond_to(:updater)
    end
    
    it "should have many images" do
      Board.make_unsaved().should respond_to(:images)
    end
    
    it "should have many reservations" do
      Board.make_unsaved().should respond_to(:reservations)      
    end

    it "should have many reserved dates" do
      Board.make_unsaved().should respond_to(:reserved_dates)
    end
    
    it "should have many black out dates" do
      Board.make_unsaved().should respond_to(:black_out_dates)
    end

    it "should be ok to do an empty check on blackout dates" do
      testboard = Board.make();
      testboard.black_out_dates.empty?.should be_true
    end

    it "should be ok to do an empty check on reserved dates" do
      testboard = Board.make();
      testboard.reserved_dates.empty?.should be_true
    end 
    
    it "should be ok to do an empty check on reservations" do
      testboard = Board.make();
      testboard.reservations.empty?.should be_true
    end  
    
    it "should be ok to do an empty check on images" do
      testboard = Board.make();
      testboard.images.empty?.should be_true
    end 

  end
  
  describe "validations" do
    it "should validate location" do
      board = Board.make_unsaved()
      board.should be_valid
       
      board.location = nil
      board.should_not be_valid
    end

    it "should validate numericality of daily fee" do
      board = Board.make_unsaved()
      board.should be_valid

      board.daily_fee = "hi jc!"
      board.should_not be_valid
    end

    it "should validate length" do
      board = Board.make_unsaved(:length=>100)
      board.should be_valid
      
      board.length = nil
      board.should_not be_valid
      
    end
    
    it "should validate maker" do
      board = Board.make_unsaved(:maker=>"Test Maker")
      board.should be_valid
      
      board.maker = ""
      board.should_not be_valid
    end
    
    it "should validate style" do
      board = Board.make_unsaved(:style=>Style.make())
      board.should be_valid
      
      board.style = nil
      board.should_not be_valid
    end
  end

  describe "nested attributes" do
    it 'should should accept nested attributes for black out dates dates' do
      Board.make().should respond_to(:black_out_dates_attributes=)
    end

    it 'should should accept nested attributes for images' do
      Board.make().should respond_to(:images_attributes=)
    end

  end

  it "should determine if it has an existing location" do
    board = Board.make()
    board.has_location?.should be_true
    
    board.location = nil
    board.has_location?.should be_false
    
    board.location_id = -1
    board.has_location?.should be_false
  end
  
#  it "should be able to find boards with new reservations" do
#    board1 = make_board_with_unavailable_dates
#    board2 = make_board_with_unavailable_dates
#    reservation_date = UnavailableDate.make()
#    board1.unavailable_dates << reservation_date
#    Board.with_new_reserved_dates_since(1.day.ago).should include(board1)
#    Board.with_new_reserved_dates_since(1.day.ago).should_not include(board2)
    
#    reservation_date.created_at = 2.days.ago
#    reservation_date.save
#    Board.with_new_reserved_dates_since(1.day.ago).should_not include(board1)    
#  end
  
#  it "should not include boards with only deleted reservation dates when finding boards with new reservation dates" do
#    board1 = make_board_with_unavailable_dates
#    board2 = make_board_with_unavailable_dates
#    active_reservation_date = UnavailableDate.make()
#    deleted_reservation_date = UnavailableDate.make(:deleted_at=>Time.now.utc)
#    board1.unavailable_dates << active_reservation_date
#    board2.unavailable_dates << deleted_reservation_date
#    Board.with_new_reserved_dates_since(1.day.ago).should include(board1)
#    Board.with_new_reserved_dates_since(1.day.ago).should_not include(board2)
#  end
  
#  it "should be able to find boards with deleted reservation dates" do
#    board1 = make_board_with_unavailable_dates
#    board2 = make_board_with_unavailable_dates
#    reservation_date1 = UnavailableDate.make(:deleted_at=>Time.now.utc)
#    reservation_date2 = UnavailableDate.make(:deleted_at=>2.days.ago)
#    board1.unavailable_dates << reservation_date1
#    board2.unavailable_dates << reservation_date2
#    Board.with_deleted_reserved_dates_since(1.day.ago).should include(board1)
#    Board.with_deleted_reserved_dates_since(1.day.ago).should_not include(board2)
#  end
  
  it "should be able to tell if a user is the owner of this board" do
    owner = User.make()
    other_user = User.make()
    board = Board.make(:creator=>owner)
    board.user_is_owner(other_user).should be_false
    board.user_is_owner(owner).should be_true
    
  end
  
  it "should be able to tell if a user has an active reservation on this board" do
    owner = User.make()
    renter = User.make()
    board = Board.make(:creator=>owner)
    res1 = Reservation.make(:creator=>renter, :board=>board)
    board.user_is_renter(renter).should be_true
    board.user_is_renter(owner).should be_false
  
    res1.destroy
    board.user_is_renter(renter).should be_false
    
  end
  
end
