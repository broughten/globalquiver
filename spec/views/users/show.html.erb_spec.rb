require 'spec_helper'

describe "/user/show" do

  describe "shop" do
    before(:each) do
      # set up the object for the view
      @user = Shop.make()
      assigns[:user] = @user
      render "users/show.html.erb"
    end
    it "should render the shop specific fields" do
      
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
      response.should include_text("Member Since")
    end
  end

end
