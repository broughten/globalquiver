require 'spec_helper'

describe "/board_searches/new" do

  before(:each) do
    @user = build_surfer
    @board_search = BoardSearch.new
    SearchLocation.make()
    @search_locations = SearchLocation.find(:all)
    assigns[:search_locations] = @search_locations
    assigns[:board_search] = @board_search
    template.controller.stubs(:current_user).returns(@user)
  end

  it "should not have a manage search locations link if not signed in as admin" do
    template.controller.stubs(:admin?).returns(true)
    render "/board_searches/new.html.erb"
    response.should include_text("Manage search locations")
  end
    
  it "should not have a manage search locations link if not signed in as admin" do
    template.controller.stubs(:admin?).returns(false)
    render "/board_searches/new.html.erb"
    response.should_not include_text("Manage search locations")

  end

end
