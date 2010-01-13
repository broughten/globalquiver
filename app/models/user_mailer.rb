class UserMailer < ActionMailer::Base
  
  # This method will send out an email to the board_owner that will
  # contain information about changes in board dates, either removals
  # or additions.
  def board_owner_reservation_update(board_owner, added_reservations, deleted_reservations)
    recipients(board_owner.email)
    from("Global Quiver <reservations@globalquiver.com>")
    subject("Board Reservation Update")
    sent_on(Time.now)    
    body({:added_reservations => added_reservations, :deleted_reservations => deleted_reservations})
  end
  
  def board_renter_reservation_details(reservation)
    recipients(reservation.creator.email)
    from("GlobalQuiver <info@globalquiver.com>")
    subject("New Board Reservation Details")
    sent_on(Time.now)    
    body({:reservation => reservation})
  end
end
