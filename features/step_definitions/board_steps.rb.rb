Given /^I have boards made by (.+)$/ do |makers|
  makers.split(', ').each do |maker|
    board = Board.new(:maker => maker)
    board.location = Location.new
    board.length = 65
    board.style = Style.new
    board.save
  end
end
