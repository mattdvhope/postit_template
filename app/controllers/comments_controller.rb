class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id]) # not params[:id] because you have to always check how it is submitted into the action...comment belongs_to post!  In a nested structure it has the name prepended to it.
    @comment = @post.comments.build(params.require(:comment).permit(:content))
                # this(above) creates new @comment object
    @comment.creator = current_user # method from application_controller.rb
        #   .user_id = current_user.id is also a possibility, but object-to-object is better in this case
    if @comment.save
      flash[:notice] = "Your comment was added."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: comment, creator: current_user, vote: params[:vote])

    if @vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "Your vote was not counted."
    end

    redirect_to :back #this ':back' says that wherever you came from, go back to that URL
  end

end