class UserMailer < ActionMailer::Base
  
  # This method will send out an email to the board_owner that will
  # contain information about changes in board dates, either removals
  # or additions.
  def board_owner_reservation_update(board_owner, added_reservations, deleted_reservations)
    recipients(board_owner.email)
    from("Global Quiver <noreply@globalquiver.com>")
    subject("Board Reservation Update")
    sent_on(Time.now)    
    body({:added_reservations => added_reservations, :deleted_reservations => deleted_reservations})
  end
  
  def board_renter_reservation_details(reservation)
    recipients(reservation.creator.email)
    from("GlobalQuiver <noreply@globalquiver.com>")
    subject("New Board Reservation Details")
    sent_on(Time.now)    
    body({:reservation => reservation})
  end

  def reservation_cancelation_details(reservation)
    recipients(reservation.creator.email)
    from("GlobalQuiver <noreply@globalquiver.com>")
    subject("Reservation Canceled")
    sent_on(Time.now)
    body({:reservation => reservation})
  end

  def password_reset_notification(user)
    recipients(user.email)
    from("GlobalQuiver <noreply@globalquiver.com>")
    subject('Link to reset your password')
    sent_on(Time.now)
    body({:user => user, :url => "#{APP_CONFIG['forgot_password_url']}/reset_password/#{user.password_reset_code}"})
  end
end
