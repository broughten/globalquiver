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

    it "should return moments ago for a comment made less than a minute ago" do
      comment_time_ago(59.seconds.ago).should == "Moments ago"
    end
    it "should return 33 minutes ago for a comment made 33 minutes ago" do
      comment_time_ago(33.minutes.ago).should == "33 minutes ago"
    end
    it "should return 1 hour 31 minutes ago for a comment made 1 hour 31 minutes ago" do
      comment_time_ago(91.minutes.ago).should == "1 hr 31 minutes ago"
    end
    it "should return 5 hours ago for a comment made 5 hours ago" do
      comment_time_ago(5.hours.ago).should == "5 hours ago"
    end
    it "should return 4 days ago for a comment made 4 days ago" do
      comment_time_ago(4.days.ago).should == "4 days ago"
    end
  end
end
