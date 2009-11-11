require 'spec_helper'

describe UserMailer do
  it "should send out an email to board owners about reservation changes" do
    board = Board.make()
    dates = Array.new
    3.times{dates << UnavailableDate.make_unsaved}

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_board_owner_board_reservation_change_notification(board.creator, {board=>dates}, {board=>dates})
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end
  
  it "should send out an email to board renters about upcoming reservations" do
    board = Board.make()
    dates = Array.new
    3.times{dates << UnavailableDate.make_unsaved}

    # Send the email, then test that it got queued
    ActionMailer::Base.deliveries.clear
    email = UserMailer.deliver_board_renter_upcoming_reservation_notification(board.creator, {board=>dates})
    ActionMailer::Base.deliveries.length.should == 1

    # Test the body of the sent email contains what we expect it to
  end
end