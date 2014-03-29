class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id]) # not params[:id] because you have to always check how it is submitted into the action...comment belongs_to post!  In a nested structure it has the name prepended to it.
    @comment = @post.comments.build(comment_params) # This will create a new 'comment' object; It sets this comment's post_id to this @post object & returns this @comment ActiveRecord object; You could have used @comment.post = @post to associate this comment object with this particular post, but instead we've used the helper method '.build' to condense this.  We also would have needed to instantiate a new @comment = Comment.new(comment_params) object to above this, but now we only need '.build'; '.build' doesn't hit the db, so we'll need '.save' below.
    @comment.creator = current_user # method from application_controller.rb
        #   .user_id = current_user.id is also a possibility, but object-to-object is better in this case
    if @comment.save
      flash[:notice] = "Your comment was added."
      redirect_to post_path(@post)
    else
      render 'posts/show' # the 'form_for' in this template expects both the @post & @comment instance variables; both @post & @comment must be instance variables (not local variables) so that they can be used in posts/show.html.erb
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html {
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "Your vote was not counted because you can only vote on a comment once."
        end
        redirect_to :back #this ':back' says that wherever you came from, go back to that URL
      }
      format.js
    end        
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end