require 'spec_helper'

describe Reservation do
  
  it "should create a vaild model from blueprint" do
    reservation = Reservation.make()
    reservation.should be_valid
  end
  
  describe "associations" do
    it "should have a creator" do
      Reservation.make_unsaved().should respond_to(:creator)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:creator_id)
    end
    
    it "should have an updater" do
      Reservation.make_unsaved().should respond_to(:updater)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:updater_id)
    end
    
    it "should have a board" do
      Reservation.make_unsaved().should respond_to(:board)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:board_id)
    end
    
    it "should have many dates" do
      Reservation.make_unsaved().should respond_to(:reserved_dates)
    end
    
    it "should belong to an invoice" do
      invoice = Invoice.make()
      reservation = Reservation.make(:invoice =>invoice)
      
      reservation.invoice.should == invoice
    end
  end
  
  describe "validations" do
    before(:each) do
      @reservation = Reservation.make_unsaved()
    end
    it "should contain at least one date" do
      @reservation.reserved_dates = []
      @reservation.should_not be_valid
    end
    
    it "should have a board" do
      @reservation.board = nil
      @reservation.should_not be_valid
    end

    it "should have an active board" do
      @board = Board.make()
      @reservation.board = @board

      @reservation.should be_valid
    end

    it "should not have an inactive board" do
      @board = Board.make()
      @reservation.board = @board
      @board.deactivate

      @reservation.should_not be_valid
    end

    it "should not destroy on a reservation that will start in less than a day" do
      @reservation.reserved_dates = [
        UnavailableDate.make(:date => Date.today),
        UnavailableDate.make(:date => 1.day.from_now)
      ]
      @reservation.save
      @reservation.destroy.should raise_error
      @reservation.deleted_at.should be_nil

    end

    it "should allow destroy on a reservation that starts more than a day away" do
      @reservation.reserved_dates = [
        UnavailableDate.make(:date => 2.days.from_now),
        UnavailableDate.make(:date => 3.day.from_now)
      ]
      @reservation.save
      @reservation.destroy
      @reservation.deleted_at.should_not be_nil

    end
  end
  
  describe "named scopes" do
    it "should be able to find reservations for a user" do
      renter = User.make()
      non_renter = User.make()
      reservation = Reservation.make(:creator=>renter)
      Reservation.for_user(renter).should include(reservation)
      
      Reservation.for_user(non_renter).should be_empty
    end

    it "should be able to find reservations for a user's boards" do
      renter = User.make()
      owner = User.make()
      board = Board.make(:creator => owner)
      board2 = Board.make(:creator => renter)
      reservation = Reservation.make(:creator=>renter, :board => board)
      reservation2 = Reservation.make(:creator=>owner, :board => board2)
      Reservation.for_boards_of_user(owner).should include(reservation)

      Reservation.for_boards_of_user(renter).should include(reservation2)
    end

    it "should be able to find new reservations for a time frame" do
      reservation = Reservation.make(:created_at=>2.days.ago)
      Reservation.created_since(1.day.ago).should_not include(reservation)
      Reservation.created_since(3.days.ago).should include(reservation)
    end

    it "should find recently deleted reservations based on a passed in date" do
      reservation1 = Reservation.make(:deleted)
      reservation2 = Reservation.make(:deleted)
      result = Reservation.deleted_since(2.days.ago)
      result.should include(reservation1)
      result.length.should == 2

      reservation1.deleted_at = 4.days.ago
      reservation1.save
      result = Reservation.deleted_since(2.days.ago)
      result.should_not include(reservation1)
      result.length.should == 1
    end

    it "should be able to find uninvoiced reservations" do
      invoiced_reservation = Reservation.make()
      uninvoiced_reservation = Reservation.make()
      invoice = Invoice.make(:reservations=>[invoiced_reservation])
      
      Reservation.uninvoiced.should include(uninvoiced_reservation)
      Reservation.uninvoiced.should_not include(invoiced_reservation)
      
    end


    it "should contain inactive that only returns the inactive records" do
      reservation1 = Reservation.make()
      reservation2 = Reservation.make()
      reservation2.destroy()
      results = Reservation.inactive
      results.should_not include(reservation1)
      results.should include(reservation2)
    end



    it "should contain active that only returns the deleted records" do
      reservation1 = Reservation.make()
      reservation2 = Reservation.make()
      reservation2.destroy()
      results = Reservation.active
      results.should include(reservation1)
      results.should_not include(reservation2)
    end
    
    it "should allow me to find reservations that occur after a certain date" do
      reservation1 = Reservation.make(:reserved_dates=>[UnavailableDate.make(:date=>2.days.from_now)])
      reservation2 = Reservation.make(:reserved_dates=>[UnavailableDate.make(:date=>4.days.from_now),UnavailableDate.make(:date=>6.days.from_now)])
      Reservation.with_dates_after(3.days.from_now).should include(reservation2)
      Reservation.with_dates_after(3.days.from_now).should_not include(reservation1)
      Reservation.with_dates_after(3.days.from_now).length.should == 1
    end
 
  end

  it "should soft delete a record by setting deleted_at" do
    reservation = Reservation.make()
    reservation.deleted_at.should be_nil

    reservation.destroy
    reservation.deleted_at.should_not be_nil
  end



  it "should allow new record to be added if a deleted one exists" do
    deleted_reservation = Reservation.make(:deleted)
    new_reservation = Reservation.make(:reserved_dates=>deleted_reservation.reserved_dates)
    new_reservation.should_not be_new_record
  end

  it "should put the reservation creator's full name when a non-creator is passed into calendar_strip_text" do
    reserver = User.make()
    non_reserver = User.make()
    reservation = Reservation.make(:creator => reserver)
    reservation.calendar_strip_text(non_reserver).should contain reserver.full_name
  end

  it "should put the board owner's full name when a reservation creator is passed into calendar_strip_text" do
    board_owner = User.make()
    reserver = User.make()
    reservation = Reservation.make(:creator => reserver)
    reservation.calendar_strip_text(reserver).should contain reservation.board.creator.full_name
  end
  
  it "should allow you to get the total cost of the reservation" do
    rental_board = Board.make()
    rental_reservation = Reservation.make(:board=>rental_board,:reserved_dates=>[UnavailableDate.make(:date=>2.days.from_now)])
    sale_board = Board.make(:for_purchase)
    sale_reservation = Reservation.make(:board=>sale_board,:reserved_dates=>[UnavailableDate.make(:date=>2.days.from_now)])
    
    rental_reservation.total_cost.should == rental_reservation.reserved_dates.count * rental_reservation.board.daily_fee
    
    sale_reservation.total_cost.should == sale_reservation.board.purchase_price
  end
  
end