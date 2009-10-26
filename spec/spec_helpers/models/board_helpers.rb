module ModelHelpers

  def make_board_with_black_out_dates(attributes = {})
    board = Board.make(attributes)
    3.times { board.black_out_dates.make }
    board
  end

end
