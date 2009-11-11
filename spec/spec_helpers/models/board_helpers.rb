module ModelHelpers

  def make_board_with_unavailable_dates(attributes = {})
    board = Board.make(attributes)
    3.times { board.unavailable_dates<< UnavailableDate.make(:creator=>board.creator) }
    board
  end

end
