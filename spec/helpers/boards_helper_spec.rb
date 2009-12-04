require 'spec_helper'
include BoardsHelper
describe BoardsHelper do
  describe "owner_html_for" do
    before(:each) do
      @user = Surfer.make()
      @owner = Shop.make()
      @board = Board.make(:creator=>@owner)
    end
    it "should return text that does not include a mailto: link if the user does not have a reservation" do
      @board.stubs(:user_is_renter).returns(false)
      result = owner_html_for(@user, @board)
      result.should_not include("mailto:") 
      result.should include(@owner.full_name)      
    end
    
    it "should return text that does not include a mailto: link if the user does not have a reservation" do
      @board.stubs(:user_is_renter).returns(false)
      result = owner_html_for(@user, @board)
      result.should_not include("mailto:") 
      result.should include(@owner.full_name)      
    end
    
    it "should return text that does include a mailto: link if you don't have a current user" do
      @board.stubs(:user_is_renter).returns(true)
      result = owner_html_for(nil, @board)
      result.should_not include("mailto:")   
      result.should include(@owner.full_name)   
    end
  end
end
