class PostsController < ApplicationController
  before_action :fetch_posts
  before_action :authenticate_user!
  
  def index
    if params[:query] == 'friends'
      @posts = Post.friends(current_user).order(created_at: :desc)
    elsif params[:query] == 'mine'
      @posts = current_user.posts.order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.create(post_params)
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(post_params)
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end
  
  private
  
  def fetch_posts
    @posts = Post.all
  end
  
  def post_params
    params.require(:post).permit(:content)
  end
end
