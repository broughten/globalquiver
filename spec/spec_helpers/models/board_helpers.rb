module ModelHelpers

  def make_board_with_unavailable_dates(attributes = {})
    board = Board.make(attributes)
    3.times { board.unavailable_dates.make }
    board
  end

end
