require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  it "should succeed creating a new valid from the blueprint" do
    User.make().should be_valid
  end
  
  describe "model associations" do
    it "should allow one image" do
      User.make().should respond_to(:image)
    end
    
    it "should have many owned boards" do
      user = User.make()
      Board.make(:creator=>user)
      Board.make(:creator=>user)
      user.owned_boards.length.should == 2
    end

    it "should allow one main_location" do
      User.make().should respond_to(:main_location)
    end
    
    it "should have many pickup_times" do
      User.make().should respond_to(:pickup_times)
    end

    it "should have many reserved boards" do
      renter = User.make()
      owner1 = User.make()
      owner2 = User.make()
      board1 = Board.make(:creator => owner1)
      board2 = Board.make(:creator => owner2)
      board3 = Board.make(:creator => owner2)
      #make one board of our own just to make sure it doesn't get included
      trickBoard = Board.make(:creator => renter)
      trickReservation  = UnavailableDate.make(:creator => renter, :board => trickBoard)
      trickReservation2 = UnavailableDate.make(:creator => renter, :board => trickBoard)
      trickReservation3 = UnavailableDate.make(:creator => renter, :board => trickBoard)

      #make more than one reservation on a couple of the boards to make sure
      #we only get back actual boards and not one item for each reserved day
      reservation1 = UnavailableDate.make(:creator => renter, :board => board1)
      reservation2 = UnavailableDate.make(:creator => renter, :board => board1)
      reservation3 = UnavailableDate.make(:creator => renter, :board => board2)
      reservation4 = UnavailableDate.make(:creator => renter, :board => board3)
      reservation5 = UnavailableDate.make(:creator => renter, :board => board3)
      reservation6 = UnavailableDate.make(:creator => renter, :board => board3)
      #so after all that, my renter should have three different boards he reserved.
      renter.reserved_boards.length.should == 3
    end

    it "should have many board reservations" do
      renter = User.make()
      owner1 = User.make()
      owner2 = User.make()
      board1 = Board.make(:creator => owner1)
      board2 = Board.make(:creator => owner2)
      board3 = Board.make(:creator => owner2)
      #make one board of our own just to make sure it doesn't get included
      trickBoard = Board.make(:creator => renter)
      trickReservation  = UnavailableDate.make(:creator => renter, :board => trickBoard)
      trickReservation2 = UnavailableDate.make(:creator => renter, :board => trickBoard)
      trickReservation3 = UnavailableDate.make(:creator => renter, :board => trickBoard)

      #make more than one reservation on a couple of the boards to make sure
      #we get back one item for each reserved day
      reservation1 = UnavailableDate.make(:creator => renter, :board => board1)
      reservation2 = UnavailableDate.make(:creator => renter, :board => board1)
      reservation3 = UnavailableDate.make(:creator => renter, :board => board2)
      reservation4 = UnavailableDate.make(:creator => renter, :board => board3)
      reservation5 = UnavailableDate.make(:creator => renter, :board => board3)
      reservation6 = UnavailableDate.make(:creator => renter, :board => board3)
      #so after all that, my renter should have 6 days worth or reserved boards.
      renter.reserved_boards.length.should == 3
    end

    it "should have many locations" do
      user = User.make()
      Location.make(:creator=>user)
      Location.make(:creator=>user)
      user.locations.length.should == 2
    end
    
  end
  
  describe "attribute validations" do
    it "should only allow an email address that contains a @ character" do
      user = User.make_unsaved(:email=>"badEmail")
      user.should_not be_valid
      
      user = User.make_unsaved(:email=>"email@email.com")
      user.should be_valid
    end
    
    it "should not allow duplicate email addresses" do
      user = User.make()
      user2 = User.make_unsaved(:email=>user.email)
      user2.should_not be_valid
    end
    
    it "should only allow passwords that are between 4 and 40 characters" do
      user = User.make_unsaved(:password=>"123")
      user.should_not be_valid
      
      user = User.make_unsaved(:password=>"12345")
      user.should be_valid
     
      user = User.make_unsaved(:password=>Faker::Lorem.words(41))
      user.should_not be_valid
    end
  end
  
  describe "authentication" do
    it "should authenticate with matching email and password" do
      user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
      User.authenticate('sl8ter@domain.com', 'good_password').should == user
    end

    it "should not authenticate with incorrect password" do
      user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
      User.authenticate('sl8ter@domain.com', 'boogieboardforever!').should be_nil
    end
  end
  
  it "should not think that it is a shop" do
      user = User.make()
      is_shop = user.is_rental_shop?
      is_shop.should == false
  end
  
  it "should not return anything for display_name" do
    user = User.make()
    display_name = user.display_name
    display_name.should == ""
  end
  
  it "should should return an empty string for full_name" do
    user = User.make()
    user.full_name.should == ""
  end
  
  it "should allow you to find all users with boards that have reservation dates created in the past day" do
    board_owner = User.make()
    board1 = make_board_with_unavailable_dates(:creator=>board_owner)
    another_board_owner = User.make()
    board2 = make_board_with_unavailable_dates(:creator=>another_board_owner)
    reservation1 = UnavailableDate.make()
    board1.unavailable_dates << reservation1
    User.has_boards_with_new_reservation_dates(1.day.ago).should include(board_owner)
    User.has_boards_with_new_reservation_dates(1.day.ago).should_not include(another_board_owner)
    User.all.should include(board_owner)
    User.all.should include(another_board_owner)
    
    reservation1.created_at = 2.days.ago
    reservation1.save
    User.has_boards_with_new_reservation_dates(1.day.ago).should_not include(board_owner)
  end
  
  it "should allow you to send an email to all users who have boards with new reservations made within the past day" do
    board_owner = User.make()
    board1 = Board.make(:creator=>board_owner)
    board2 = Board.make(:creator=>board_owner)
    another_board_owner = User.make()
    board3 = make_board_with_unavailable_dates(:creator=>another_board_owner)
    reservation1 = UnavailableDate.make()
    board1.unavailable_dates << reservation1
    ActionMailer::Base.deliveries.clear
    User.send_reservation_status_change_update
    # you should only have one email to board_owner
    ActionMailer::Base.deliveries.length.should == 1
    email = ActionMailer::Base.deliveries.first
    # that email should contain only dates for board1
    email.body.should contain(board1.maker)
    email.body.should_not contain(board2.maker)
    
    #push back the creation of the reservation
    reservation1.created_at = 2.days.ago
    reservation1.save
    ActionMailer::Base.deliveries.clear
    User.send_reservation_status_change_update
    ActionMailer::Base.deliveries.length.should == 0
  end
end