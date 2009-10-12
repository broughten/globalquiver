Given /^I have boards made by (.+)$/ do |makers|
  makers.split(', ').each do |maker|
    board = Board.new(:maker => maker)
    board.location = Location.new
    board.length = 65
    board.style = Style.new
    board.save
  end
end


Given /^I have no boards$/ do
  Board.delete_all
end

Then /^I should see "([^\"]*)""$/ do |arg1|
  pending
end

Then /^I should have ([0-9]+) board$/ do |count|
  Board.count.should == count.to_i
end
