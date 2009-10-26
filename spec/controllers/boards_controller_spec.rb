require 'spec_helper'

describe BoardsController do
  integrate_views

  #Delete these examples and add some real ones
  it "should use BoardsController" do
    controller.should be_an_instance_of(BoardsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :edit, :create, :update, :destroy
  end

end
