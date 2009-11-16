require 'spec_helper'

describe "pages/overview.html.erb" do

  describe "surfer view" do
    describe "surfer has boards in his quiver" do
      before(:each) do
        @user = build_surfer
        template.controller.stubs(:current_user).returns(@user)
        build_boards(10,@user)
        assigns[:user] = @user
        render "pages/overview.html.erb"
      end

      it "should have surfer info text" do
        response.should include_text("Boards you've added to the Global Quiver")
      end

      it "should display a delete link for each board" do
        @user.owned_boards.each {|board| response.should have_selector("a", :href=>"/boards/#{board.id}")}
      end
    end
  end

  describe "shop view" do
    describe "shop has boards in its quiver" do
      before(:each) do
        @user = build_shop
        template.controller.stubs(:current_user).returns(@user)
        build_boards(10,@user)
        assigns[:user] = @user
        render "pages/overview.html.erb"
      end

      it "should have shop info text" do
        response.should include_text("Below are the boards you are tracking via Global Quiver")
      end
    end
  end
end