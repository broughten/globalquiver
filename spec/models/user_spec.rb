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
      user.boards.length.should == 2
    end

    it "should have many reservations" do
      User.make_unsaved().should respond_to(:reservations)
    end
    
    it "should have many pickup_times" do
      User.make().should respond_to(:pickup_times)
    end
    
    it "should allow you to find all reservations for owned boards" do
      owner1 = User.make()
      reservation = Reservation.make(:board=>Board.make(:creator=>owner1))
      owner2 = User.make()
      owner1.reservations_for_owned_boards.should include(reservation)
      owner1.reservations_for_owned_boards.count.should == 1
      owner2.reservations_for_owned_boards.should be_empty
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
  
  
  
  it "should allow you to find all users with reservations on owned boards that have been created since a certain date" do
    board_owner = User.make()
    board1 = Board.make(:creator=>board_owner)
    another_board_owner = User.make()
    board2 = Board.make(:creator=>another_board_owner)
    reservation1 = Reservation.make(:board=>board1)
    User.with_reservations_for_owned_boards_created_since(1.day.ago).should include(board_owner)
    User.with_reservations_for_owned_boards_created_since(1.day.ago).should_not include(another_board_owner)
    User.all.should include(board_owner)
    User.all.should include(another_board_owner)
  
    reservation1.created_at = 2.days.ago
    reservation1.save
    User.with_reservations_for_owned_boards_created_since(1.day.ago).should_not include(board_owner)
  end
  
  it "should allow you to send an email to all board owners who have boards with new reservations" do
    board_owner = User.make()
    board1 = Board.make(:creator=>board_owner)
    board2 = Board.make(:creator=>board_owner)
    reservation1 = Reservation.make(:board=>board1)
    reservation2 = Reservation.make(:board=>board1, :created_at=>2.days.ago)
    
     ActionMailer::Base.deliveries.clear
    User.send_reservation_update_for_owned_boards(1.day.ago)
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
    User.send_reservation_update_for_owned_boards(1.day.ago)
    ActionMailer::Base.deliveries.length.should == 0
  end
  
#  it "should allow you to send an email to all users who have boards with deleted reservations made within the past day" do
#    board_owner = User.make()
#    board1 = Board.make(:creator=>board_owner)
#    board2 = Board.make(:creator=>board_owner)
#    another_board_owner = User.make()
#    board3 = make_board_with_unavailable_dates(:creator=>another_board_owner)
#    reservation1 = UnavailableDate.make(:deleted_at=>Time.now.utc)
#    board1.unavailable_dates << reservation1
#    ActionMailer::Base.deliveries.clear
#    User.send_reservation_status_change_update
    # you should only have one email to board_owner
#    ActionMailer::Base.deliveries.length.should == 1
#    email = ActionMailer::Base.deliveries.first
    # that email should contain only dates for board1
#    email.body.should contain(board1.maker)
#    email.body.should_not contain(board2.maker)
    
    #push back the creation of the reservation
#    reservation1.deleted_at = 2.days.ago
#    reservation1.save
#    ActionMailer::Base.deliveries.clear
#    User.send_reservation_status_change_update
#    ActionMailer::Base.deliveries.length.should == 0
#  end
end
