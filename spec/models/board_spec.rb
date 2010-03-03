require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec_helper'

describe Board do

  it "should create a new instance from blueprint" do
    Board.make().should be_valid
  end
  
  describe "attributes" do
    it "should have an for_purchase flag" do
      Board.make_unsaved().should respond_to(:for_purchase?)
    end
    
    it "should default for_purchase flag to false" do
      board = Board.make()
      board.for_purchase.should be_false
    end
    
    it "should have a purchase_price field" do
      Board.make_unsaved().should respond_to(:purchase_price)
    end
    
    it "should have a buy_back_price field" do
      Board.make_unsaved().should respond_to(:buy_back_price)
    end
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

    it "should validate numericality of daily fee for non for purchase boards" do
      board = Board.make_unsaved(:for_purchase=>false, :daily_fee=>"hello")
      board.should_not be_valid
      
      board.daily_fee = 20
      board.should be_valid
    end
    
    it "should validate numericality of purchase_price and buy_back_price for purchasable boards" do
      board = Board.make_unsaved(:for_purchase=>true, :purchase_price=>"hello", :buy_back_price=>"hello")
      board.should_not be_valid
      
      board.purchase_price = 35
      board.should_not be_valid
      
      board.buy_back_price = 35
      board.should be_valid
    end

    it "should validate name" do
      board = Board.make_unsaved(:name => "Big Blue")
      board.should be_valid

      board.name = nil
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
  
  it "should allow you to deactive a board" do
    board = Board.make()
    board.should be_active
    
    board.deactivate
    
    board.should_not be_active
  end
  
  it "should allow you to activate a board" do
    board = Board.make()
    board.deactivate
    
    board.should_not be_active
    
    board.activate
    board.should be_active
  end
  
  it "should allow you to find only the active boards" do
    board1 = Board.make()
    board2 = Board.make()
    board2.deactivate
    board2.save
    
    Board.active.should include board1
    Board.active.should_not include board2
  end
  
  it "should allow you to get a status string from the board" do
    board = Board.make()
    board.status.should == "Active"
    
    board.deactivate
    board.status.should == "Inactive"
    
  end
  
  it "should be able to tell if it has future reservations" do
    reserved_board = Board.make()
    unreserved_board = Board.make()
    reservation = Reservation.make(:board=>reserved_board,:reserved_dates=>[UnavailableDate.make(:date=>2.days.from_now)])
    
    reserved_board.has_future_reservations.should be_true
    unreserved_board.has_future_reservations.should be_false
  end
  
  it "should be able to tell if it is a generic board" do
    generic_board = GenericBoard.make_unsaved()
    specific_board = SpecificBoard.make_unsaved()
    board = Board.make_unsaved()
    
    generic_board.is_generic?.should be_true
    specific_board.is_generic?.should be_false
    board.is_generic?.should be_false
  end
  
end
