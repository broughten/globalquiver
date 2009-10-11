require 'spec_helper'

describe BoardsController do

  #Delete these examples and add some real ones
  it "should use BoardsController" do
    controller.should be_an_instance_of(BoardsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
