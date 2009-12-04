require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  it "should succeed creating a new valid user from the blueprint" do
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
    
    it "should only show reserved boards with active unavailable dates" do
      renter = User.make()
      owner1 = User.make()
      board1 = Board.make(:creator => owner1)
      board2 = Board.make(:creator => owner1)
      # make up the reservations
      reservation1 = UnavailableDate.make(:creator => renter, :board => board1, :deleted_at=>Time.now.utc)
      reservation2 = UnavailableDate.make(:creator => renter, :board => board2)
      #so after all that, my renter should have one different board he reserved because board1 has only deleted dates.
      renter.reserved_boards.should_not include(board1)
      renter.reserved_boards.should include(board2)
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
      renter.board_reservations.length.should == 6
    end
    
    it "should only return board reservations that are not deleted" do
      renter = User.make()
      owner1 = User.make()
      board1 = Board.make(:creator => owner1)

      #make more than one reservation on a couple of the boards to make sure
      #we get back one item for each reserved day
      reservation1 = UnavailableDate.make(:creator => renter, :board => board1)
      reservation2 = UnavailableDate.make(:creator => renter, :board => board1, :deleted_at=>Time.now.utc)
      #so after all that, my renter should have 1 days worth or reserved boards because the 
      # second one is deleted.
      renter.board_reservations.length.should == 1
    end



    describe "locations schmoekations" do
      it "should allow one location" do
        user = User.make()
        location = Location.make()
        user.location = location

        #you can't access user_location when location_id is a foreign_key into something other than a user location
        user.location.class.to_s.should eql "Location"
        user.user_location.should be_nil

        user_location = UserLocation.make()
        user.location = user_location

        #But when location_id is a foreign key into a user location, you can access it via either location, or user_location
        user.location.class.to_s.should eql "UserLocation"
        user.user_location.should_not be_nil
      end

      it "should allow one user location" do
        user = User.make()
        user_location = UserLocation.make()
        
        user.user_location = user_location
        #see now we can access the user location via either accessor
        user.location.class.to_s.should eql "UserLocation"
        user.user_location.class.to_s.should eql "UserLocation"


      end
      it "should have many locations" do
        user = User.make()
        Location.make(:creator=>user)
        Location.make(:creator=>user)
        user.locations.length.should == 2
      end

      it "should have many board locations" do
        user = User.make()
        BoardLocation.make(:creator=>user)
        Location.make(:creator=>user)
        BoardLocation.make(:creator=>user)
        Location.make(:creator=>user)
        BoardLocation.make(:creator=>user)
        user.board_locations.length.should == 3
      end
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
    User.has_boards_with_reservation_date_changes_since(1.day.ago).should include(board_owner)
    User.has_boards_with_reservation_date_changes_since(1.day.ago).should_not include(another_board_owner)
    User.all.should include(board_owner)
    User.all.should include(another_board_owner)
    
    reservation1.created_at = 2.days.ago
    reservation1.save
    User.has_boards_with_reservation_date_changes_since(1.day.ago).should_not include(board_owner)
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
  
  it "should allow you to send an email to all users who have boards with deleted reservations made within the past day" do
    board_owner = User.make()
    board1 = Board.make(:creator=>board_owner)
    board2 = Board.make(:creator=>board_owner)
    another_board_owner = User.make()
    board3 = make_board_with_unavailable_dates(:creator=>another_board_owner)
    reservation1 = UnavailableDate.make(:deleted_at=>Time.now.utc)
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
    reservation1.deleted_at = 2.days.ago
    reservation1.save
    ActionMailer::Base.deliveries.clear
    User.send_reservation_status_change_update
    ActionMailer::Base.deliveries.length.should == 0
  end
end
