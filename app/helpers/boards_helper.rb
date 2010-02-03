module BoardsHelper
 
  def fractions
    [
      ['fractional inches', '0'],
      ['0' , '0'],
      ['1/16' , '0.0625'],
      ['1/8' , '0.125'],
      ['3/16' , '0.1875'],
      ['1/4' , '0.25'],
      ['5/16' , '0.3125'],
      ['3/8' , '0.375'],
      ['7/16' , '0.4375'],
      ['1/2' , '0.5'],
      ['9/16' , '0.5625'],
      ['5/8' , '0.625'],
      ['11/16' , '0.6875'],
      ['3/4' , '0.75'],
      ['13/16' , '0.8125'],
      ['7/8' , '0.875'],
      ['15/16' , '0.9375']
    ]
  end
  
  def submit_button_text_for(user, board)
    # determine who is viewing the board details
    # page and return a string based on that
    button_text = 'Save Reservation' # assume its not the board owner.    
    button_text = 'Save Board Availability' if  board.user_is_owner(user)    
    return button_text    
  end
  
  def owner_html_for(user, board)
    if !user.nil? && board.user_is_renter(user)
      "<a href='mailto:#{h(board.creator.email)}' title='Email Me!'>#{h(board.creator.full_name)}</a>"
    else
     board.creator.full_name
    end
  end

  def comment_time_ago(time)
    if Time.now - time < 60
      answer = "Moments ago"
    elsif Time.now - time < 60 * 60
      answer = "#{(Time.now - time).div(60)} minutes ago"
    elsif Time.now - time < 2 * 60 * 60
      answer = "1 hr #{(Time.now - time).div(60) - 60} minutes ago"
    elsif Time.now - time < 24 * 60 * 60
      answer = "#{(Time.now - time).div(60 * 60)} hours ago"
    else
      answer = "#{(Time.now - time).div(60 * 60 * 24)} days ago"
    end
    return answer
  end

  def owner_comment(comment, board)
    if comment.user == board.creator
      return "owner"
    else
      return ""
    end
  end
end