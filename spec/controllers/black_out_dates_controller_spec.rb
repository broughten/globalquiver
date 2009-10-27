require 'spec_helper'

describe BlackOutDatesController do
  integrate_views
  fixtures :black_out_dates

  it "should use BlackOutDatesController" do
    controller.should be_an_instance_of(BlackOutDatesController)
  end


  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :edit, :create, :update, :destroy
  end
end
