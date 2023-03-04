class Public::PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page])
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
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end
  
  private
  
  def post_params
    params.require(:post).permit(:item_name, :purchased_at, :produced_by, :review, :rate, :image)
  end
  
end
