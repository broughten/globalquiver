require 'spec_helper'

describe "/user/edit" do

  describe "shop" do
    before(:each) do
      # set up the object for the view
      @user = Shop.make()
      assigns[:user] = @user
      render "users/edit.html.erb"
    end
    it "should render the shop specific fields" do
      response.should have_selector("form[method=post]") do |form|
          form.should have_selector("input[type=text]", :name=>"shop[name]")
          form.should have_selector("input[type=text]", :name=>"shop[email]")
          form.should have_selector("input[type=password]", :name=>"shop[password]")
          form.should have_selector("input[type=password]", :name=>"shop[password_confirmation]")
          form.should have_selector("input[type=file]", :name=>"shop[image_attributes][data]")
          form.should have_selector("input[type=submit]")
      end
    end
    
  end
  
  describe "surfer" do
    before(:each) do
      # set up the object for the view
      @user = Surfer.make()
      assigns[:user] = @user
      render "users/edit.html.erb"
    end
    it "should render the shop specific fields" do
      response.should have_selector("form[method=post]") do |form|
          form.should have_selector("input[type=text]", :name=>"surfer[first_name]")
          form.should have_selector("input[type=text]", :name=>"surfer[first_name]")
          form.should have_selector("input[type=text]", :name=>"surfer[email]")
          form.should have_selector("input[type=password]", :name=>"surfer[password]")
          form.should have_selector("input[type=password]", :name=>"surfer[password_confirmation]")
          form.should have_selector("input[type=file]", :name=>"surfer[image_attributes][data]")
          form.should have_selector("input[type=submit]")
      end
    end
  end

end
