class UserMailer < ActionMailer::Base
  
  # This method will send out an email to the board_owner that will
  # contain information about changes in board dates, either removals
  # or additions.
  # The date_additions parameter will contain a hash with a board object as the key
  # and an array of added dates as the value.
  # The date_removals parameter will contain a hash with a board object as the key
  # and an array of removed dates as the value. 
  def board_owner_board_date_change_notification(board_owner, board_date_additions, board_date_removals)
    recipients(board_owner.email)
    from("GlobalQuiver <info@globalquiver.com>")
    subject("Board Status Update")
    sent_on(Time.now)    
    body({:date_additions => board_date_additions, :date_removals => board_date_removals})
  end
  
  # This method will send out an email to the board_renter that will
  # contain information about upcoming reservations
  # The board_rental_dates parameter will contain a hash with a board object as the key
  # and an array of rental dates as the value.
  def board_renter_upcoming_reservation_notification(board_renter, board_rental_dates)
    recipients(board_renter.email)
    from("GlobalQuiver <info@globalquiver.com>")
    subject("Upcoming Board Reservation")
    sent_on(Time.now)    
    body({:board_rental_dates => board_rental_dates})
  end

end
