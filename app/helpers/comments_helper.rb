module CommentsHelper
 
  def owner_comment(comment, board)
    if comment.user == board.creator
      return "owner"
    else
      return ""
    end
  end

  def deleted_comment(comment)
    comment.body == "Comment deleted by user"?"deleted":""
  end
end
