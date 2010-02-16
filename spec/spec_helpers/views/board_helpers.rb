module ViewHelpers
  def build_specific_boards(number, user)
    number.times {SpecificBoard.make(:creator=>user,:updater=>user)}
  end
end