require 'spec_helper'

describe UserMailer do
  it "should send out an email to board owners about reservation changes" do
    reservation = Reservation.make()

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_board_owner_reservation_update(reservation.board.creator, [reservation], [reservation])
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end
  
  it "should send out an email to the board renter about reservation details" do
    reservation = Reservation.make()

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_board_renter_reservation_details(reservation)
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end

  it "should send out an email to the board renter about reservation cancelation details" do
    reservation = Reservation.make()

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_reservation_cancelation_details(reservation)
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end

  it "should send out an email to the user renter about resetting password" do
    user = User.make()

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_password_reset_notification(user)
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end
  
end