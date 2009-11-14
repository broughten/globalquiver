require 'spec_helper'

describe "pages/overview.html.erb" do
  
  describe "user has boards in their quiver" do
    before(:each) do
      @user = User.make
      build_boards(10,@user)
      assigns[:user] = @user
      render "pages/overview.html.erb"
    end
  
    it "should have a create board link" do
      response.should have_selector("a", :href=> new_board_path)
    end
  
    it "should display a delete link for each board" do
      @user.owned_boards.each {|board| response.should have_selector("a", :href=>"/boards/#{board.id}")}
    end
    
  end
end