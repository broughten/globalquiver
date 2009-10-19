module ViewHelpers
  def build_boards(number, user)
    number.times {Board.make(:creator=>user,:updater=>user)}
  end
end