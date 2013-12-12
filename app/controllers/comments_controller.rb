class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id]) # not params[:id] because you have to always check how it is submitted into the action...comment belongs_to post!  In a nested structure it has the name prepended to it.
    @comment = @post.comments.build(params.require(:comment).permit(:content))
                # this(above) creates new @comment object
    @comment.creator = User.first # fix after authentication

    if @comment.save
      flash[:notice] = "Your comment was added."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

end