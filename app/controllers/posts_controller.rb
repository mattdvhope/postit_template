class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update] # the instance variable in the set_post method are now immediately accessible to these actions in the brackets here.
  # Reasons for before_action
  # 1. set up a DRY instance variable for action
  # 2. redirect based on some condition

  def index
    @posts = Post.all
  end

  def show
    # the instance method here is now in the set_post method at the bottom
  end

  def new
    @post = Post.new
  end

  def create
    # the instance method here is now in the set_post method at the bottom

    if @post.save
    # binding.pry
      flash[:notice] = "Your post was created"
      redirect_to posts_path
    else # validation error
      render "new" # we cannot do redirect_to b/c we want to display the .errors on 'new' template
    end

  end

  def edit # url is... /posts/3/edit , etc...
    # the instance method here is now in the set_post method at the bottom
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "The post was updated"
      redirect_to post_path
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit! # permit everything
  end

  def set_post # this makes the "show, edit, & update" methods DRY
    @post = Post.find(params[:id])
  end

end
