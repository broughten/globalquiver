require 'spec_helper'

describe CommentsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use BoardsController" do
    controller.should be_an_instance_of(CommentsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    
    describe "reply to comment" do
      before(:each) do
        @temp_board = Board.make()
        @temp_comment = Comment.build_from(@temp_board, @user.id, "this is a comment" )
        @temp_comment.save
      end
      it "should attempt to find the comment in question" do
        xhr :post, 'reply', {:id => @temp_comment.id, :reply => {:body => "comment"}}
        assigns[:comment].should == @temp_comment
      end

      it "should attempt to build a reply that is the child of the original comment" do
        xhr :post, 'reply', {:id => @temp_comment.id, :reply => {:body => "comment"}}
        assigns[:reply].parent_id.should == @temp_comment.id
      end

      it "should attempt to save the reply" do
        Comment.any_instance.expects(:save)
        xhr :post, 'reply', {:id => @temp_comment.id, :reply => {:body => "comment"}}
      end

      it "should send an email to the original commentor if the replier is not the same person" do
        UserMailer.expects(:deliver_comment_notification)
        other_user = User.make()
        board = Board.make()
        comment = Comment.build_from(board, other_user.id, "this is a comment");
        comment.save
        xhr :post, 'reply', {:id => comment.id, :reply => {:body => "reply"}}

      end

      it "should render an alert if the comment fails to save" do
        Comment.any_instance.stubs(:valid?).returns(false)
        xhr :post, 'reply', {:id => @temp_comment.id, :reply => {:body => "comment"}}
        response.should contain("add your reply. Refresh this page and try again.');")
      end

      it "should render an alert if it can't find the initial comment" do
        xhr :post, 'reply', {:id => "12312312", :reply => {:body => "comment"}}
        response.should contain("find the comment you are replying to")
      end
    end

    describe "delete comment" do
      before(:each) do
        @temp_board = Board.make()
        @temp_comment = Comment.build_from(@temp_board, @user.id, "this is a comment" )
        @temp_comment.save
      end
      it "should attempt to find the comment in question" do
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
        assigns[:comment].should == @temp_comment
      end

      it "should attempt to determin if the passed in comment is a leaf node" do
        Comment.any_instance.expects(:leaf?)
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
      end

      it "should attempt to delete leaf node comments" do
        Comment.any_instance.stubs(:leaf?).returns(true)
        Comment.any_instance.expects(:destroy)
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
      end

      it "should attempt to update and save non-leaf node comments" do
        Comment.any_instance.stubs(:leaf?).returns(false)
        Comment.any_instance.expects(:save)
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
        assigns[:comment].body.should == "Comment deleted by user"
      end

      it "should render an alert if the comment fails to save" do
        Comment.any_instance.stubs(:leaf?).returns(false)
        Comment.any_instance.stubs(:valid?).returns(false)
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
        response.should contain("Ooops! Deletion failed.")
      end
      
      it "should render an alert if the comment fails to delete" do
        Comment.any_instance.stubs(:leaf?).returns(true)
        Comment.any_instance.stubs(:destroy).returns(false)
        xhr :post, 'destroy', {:id => @temp_comment.id, "_method" => "delete"}
        response.should contain("able to delete this comment")
      end

      it "should render an alert if it can't find the initial comment" do
        xhr :post, 'reply', {:id => "12312312"}
        response.should contain("find the comment you are replying to")
      end
    end
  end

  describe "anonymous user" do

    it "reply action should require authentication" do

      post 'reply', {:id => "1", :reply => {:body => "comment"}}
        
      response.should redirect_to(login_path)
    end

  end

end
