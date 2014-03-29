class PostsController < ApplicationController
  # Reasons for before_action
  # 1. set up a DRY instance variable for action...
  before_action :set_post, only: [:show, :edit, :update, :vote] # the instance variable in the set_post method are now immediately accessible to these actions in the brackets here.
  before_action :user_count, only: [:new, :create, :edit, :update]
  # 2. redirect away from action based on some condition...
  before_action :require_user, except: [:index, :show] #the :require_user method (the requirement of having a user password) will be written in the application_controller.rb since it will be used application-wide
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|post| post.total_votes}.reverse
  end

  def show
    # the instance method here is now in the set_post method at the bottom
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user # 'current_user' method comes from application_controller.rb

    if @post.save
      flash[:notice] = "Your post was created"
      redirect_to posts_path
    else # validation error --> goes to _form.html.erb, lines 1-10
        render "new" # we cannot do redirect_to b/c we want to display the .errors on 'new' template
    end

  end

  def edit # url is... /posts/3/edit , etc...
    # the instance method here is now in the set_post method at the bottom
  end

  def update
    # the instance method here is now in the set_post method at the bottom
    if @post.update(post_params)
      flash[:notice] = "The post was updated"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote #this not our normal CRUD work-flow; it's just a link, not a form
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format| #retain 'format.html' to allow for graceful degradation (i.e., Internet explorer that can't use JS)
      format.html { #where we put the code for our normal flow (BTW, the .html method can take a code block)
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "Your vote was not counted because you can only vote on a post once." # Since we're not using a traditional model-backed form here, we're using the flash[:error] in the controller rather than iterating through an array of error messages in the [model-backed] form.
        end
        redirect_to :back #this ':back' says that wherever you came from, go back to that URL
      }
    # format.js { render json: @post }   #where we put the code for our ajax-ified flow
                       # json: @post returns a hash-like structure; whoever made this json call now needs to parse this hash-like structure and use its data
      format.js #with no code-block here, its default action is to render a template (just like an empty method in the controller would render its named template), but in this case it renders a javascript template rather than an html template; with it, I have access to the instance variables in this action ('vote')
    end     # this JS requestion immediately above was sent from 'posts/_post.html.erb' via the 'remote: true'
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, :user_id, category_ids:[]) # Need the [] to set an array of category_ids here; In posts/_form.html.erb, :category_ids is a virtual attribute that will submit all of the values in an array format through the key called ':category_ids' ...then on the action side (in posts_controller.rb) we can mass-assign; we're taking advantage of this model-backed helper method #collection_check_boxes so that the values will persist on the edit side
  # params.require(:post).permit(:title, :url) # permits only title and url; this is a Rails 4 requirement.
  end

  def set_post # this makes the "show, edit, update & vote" methods DRY
    @post = Post.find_by(slug: params[:id]) # The slug will still come in with a key of :id(routing convention).  #slug comes from the post.rb model--it is a column in the posts table.
  end          # find_by is a Rails 4 method for finding via any attribute of the object.

  def require_creator # Might be better-named, 'require_creator_or_admin'.
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?) # We have access to @post b/c the 'before_action :set_post' action happens before (is in the line above) the 'before_action :require_creator' action.
  end                  # logged_in? is very necessary here in order to avoid a nil error--in order to be sure to have a current_user.

  def user_count
     @user_count = User.all
  end

end