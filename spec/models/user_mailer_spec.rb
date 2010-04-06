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

  it "should send out an email to the recipient of a comment (board owner or original commentor)" do
    user = User.make()
    user2 = User.make()
    board = Board.make(:creator => user)
    comment = Comment.build_from(board, user2.id, "this is a comment" )

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_comment_notification(user, user2, comment)
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end
  
  it "should send out an email to the responsible user for an invoice" do
    make_uninvoiced_reservation_and_get_shop
    
    invoices = Invoice.create_invoices_for_uninvoiced_reservations
    
    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    #there should be only one invoice in the array because you only created one
    email = UserMailer.deliver_invoice_notification(invoices.first) 
    ActionMailer::Base.deliveries.length.should == 1
    
  end
  
end