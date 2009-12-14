class UserMailer < ActionMailer::Base
  
  # This method will send out an email to the board_owner that will
  # contain information about changes in board dates, either removals
  # or additions.
  def board_owner_reservation_update(board_owner, added_reservations, deleted_reservations)
    recipients(board_owner.email)
    from("GlobalQuiver <info@globalquiver.com>")
    subject("Board Reservation Update")
    sent_on(Time.now)    
    body({:added_reservations => added_reservations, :deleted_reservations => deleted_reservations})
  end
end
