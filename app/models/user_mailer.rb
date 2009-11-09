class UserMailer < ActionMailer::Base
  
  # This method will send out an email to the board_owner that will
  # contain information about changes in board dates, either removals
  # or additions.
  # The date_additions parameter will contain a hash with a board object as the key
  # and an array of added dates as the value.
  # The date_removals parameter will contain a hash with a board object as the key
  # and an array of removed dates as the value. 
  def board_owner_board_date_change_notification(board_owner, date_additions, date_removals)
    recipients(board_owner.email)
    from("GlobalQuiver <info@globalquiver.com>")
    subject("Board Status Udate")
    sent_on(Time.now)    
    body({:date_additions => date_additions, :date_removals => date_removals})
  end

end
