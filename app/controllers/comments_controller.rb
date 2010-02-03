class CommentsController < ApplicationController

  before_filter :login_required

  def destroy
    respond_to do |format|
      begin
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @comment = nil
      ensure
        if @comment.nil?
          render :inline => "alert('Ooops! We couldn\\'t find the comment you were deleting. Refresh this page and try again');"
          return
        end
      end
      @id_to_remove = @comment.id
      if @comment.leaf?
        if @comment.destroy
          format.js
        else
          format.js {
            render :inline => "alert('Ooops! We weren\\'t able to delete this comment. Refesh this page and try again.');"
          }
        end
      else
        @comment.body = "Comment deleted by user"
        if @comment.save
          format.js
        else
          format.js {
            render :inline => "alert('Ooops! Deletion failed. Please refresh this page and try again.');"
          }
        end
      end
    end
  end

  def reply
    respond_to do |format|
      begin
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @comment = nil
      ensure
        if @comment.nil?
          render :inline => "alert('Ooops! We couldn\\'t find the comment you are replying to. Refresh this page and try again.');"
          return
        end
      end
      @board = Comment.find_commentable("Board", @comment.commentable_id)
      @reply = Comment.build_from(@board, current_user.id, params[:reply][:body] )

      if @reply.save
        @reply.move_to_child_of(@comment)
        format.js
      else
        format.js {
          render :inline => "alert('Ooops! We couldn\\'t add your reply. Refresh this page and try again.');"
        }
      end
    end
  end

end
