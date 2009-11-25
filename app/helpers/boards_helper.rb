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
end
