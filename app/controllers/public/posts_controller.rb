class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    @posts = Post.order(created_at: :desc).page(params[:page])
  end
  
  def filter
    @posts = Post.where(rate: params[:post][:rate]).page(params[:page])
    render :index
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split(/[[:blank:]]+/)
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post)
    else
      render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_path(post.user)
  end
  
  def edit
    @post = Post.find(params[:id])
    @tag = @post.tags
  end
  
  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(/[[:blank:]]+/)
    if @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:item_name, :purchased_at, :produced_by, :review, :rate, :image)
  end
  
end
