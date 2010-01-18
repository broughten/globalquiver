require 'spec_helper'

describe "/user/show" do

  describe "authenticated user" do
    describe "shop" do
      before(:each) do
        # set up the object for the view
        @user = Shop.make()
        template.controller.stubs(:current_user).returns(@user)
        assigns[:user] = @user
        render "users/show.html.erb"
      end
      it "should render the shop specific fields" do
        response.should_not include_text("Member Since")
      end

    end

    describe "surfer" do
      before(:each) do
        # set up the object for the view
        @user = Surfer.make()
        template.controller.stubs(:current_user).returns(@user)
        assigns[:user] = @user
        render "users/show.html.erb"
      end
      it "should render the surfer specific info" do
        response.should include_text("Member Since")
      end
    end
  end

  describe "anonymous user" do
        describe "shop" do
      before(:each) do
        # set up the object for the view
        @user = Shop.make()
        assigns[:user] = @user
        render "users/show.html.erb"
      end
      it "should render the shop specific fields" do
        response.should include_text("About")
        response.should include_text("to see more info")
      end

    end

    describe "surfer" do
      before(:each) do
        # set up the object for the view
        @user = Surfer.make()
        assigns[:user] = @user
        render "users/show.html.erb"
      end
      it "should render the surfer specific info" do
        response.should include_text("says")
        response.should include_text("to see more info")
      end
    end
  end
end
