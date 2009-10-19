require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "overviews/index.html.erb" do
  before(:each) do
    build_boards(10,User.make)
  end
  it "should display a list of the users boards" do
    # response.should have_selector("your_boards")
    # response.should have_selecto("div.board")
  end
end