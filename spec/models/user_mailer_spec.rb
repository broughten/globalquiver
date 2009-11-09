require 'spec_helper'

describe UserMailer do
  it "should send out an email for new reserved dates" do
    board = Board.make()
    dates = Array.new
    3.times{dates << UnavailableDate.make_unsaved.date}

    # Send the email, then test that it got queued
    email = UserMailer.deliver_board_owner_board_date_change_notification(board.creator, {board=>dates}, {board=>dates})
    ActionMailer::Base.deliveries.should_not be_empty

    # Test the body of the sent email contains what we expect it to
  end
end