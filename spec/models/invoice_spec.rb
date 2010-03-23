require 'spec_helper'

describe Invoice do
  before(:each) do
    
  end

  it "should create a new instance given valid attributes" do
    Invoice.make().should be_valid
  end
  
  describe "associations" do
    it "should have a user responsible for the invoice" do
      Invoice.make_unsaved.should respond_to(:responsible_user)
    end
    
    it "should associate a User with the responsible_user" do
      user = User.make()
      invoice = Invoice.make(:responsible_user => user)
      
      invoice.responsible_user.should == user
      
    end
  end
  
  
end
