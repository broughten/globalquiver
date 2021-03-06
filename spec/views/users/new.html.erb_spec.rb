require 'spec_helper'

describe "/user/new" do
  
  before(:each) do
    render "users/new.html.erb"
  end

  it "should have a multipart form with fields for the required fields" do
    response.should have_selector("form[method=post]", :action => users_url) do |form|
      form.should have_selector("input[type=checkbox]", :name=>"is_shop")
      form.should have_selector("input[type=text]", :name=>"user[first_name]")
      form.should have_selector("input[type=text]", :name=>"user[last_name]")
      form.should have_selector("input[type=text]", :name=>"user[name]")
      form.should have_selector("input[type=text]", :name=>"user[email]")
      form.should have_selector("input[type=password]", :name=>"user[password]")
      form.should have_selector("input[type=password]", :name=>"user[password_confirmation]")
      form.should have_selector("input[type=checkbox]", :name=>"user[terms_of_service]")
      form.should have_selector("input[type=submit]")
    end
    
  end
  
end
