require 'spec_helper'

describe "/session/new" do
  
  it "should have a form with text fields for the required fields" do
    render "sessions/new.html.erb"
    response.should have_selector("form[method=post]", :action => session_path) do |form|
      form.should have_selector("input[type=text]", :name=>"session[email]")
      form.should have_selector("input[type=password]", :name=>"session[password]")
      form.should have_selector("input[type=submit]")
    end
  end
  
  it "should have a link that sends you to the create user page" do
    render "sessions/new.html.erb"
    response.should have_selector("a", :href=> new_user_path)
  end

  
end
