class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id]) # not params[:id] because you have to always check how it is submitted into the action...comment belongs_to post!  In a nested structure it has the name prepended to it.
    @comment = @post.comments.build(comment_params)
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
    # Line below: Instead of using 'comment = Comment.find(params[:id])' & voteable: comment (below-where 'voteable' parses out the voteable_type & voteable_id), I used the individual columns/attributes of 'Vote'. This is another way of doing the same thing.
    vote = Vote.create(voteable_type: "Comment", voteable_id: params[:id], creator: current_user, vote: params[:vote])

    if vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "Your vote was not counted because you can only vote on a comment once."
    end

    redirect_to :back #this ':back' says that wherever you came from, go back to that URL
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end