class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post)
  end
  
  def show
  end
  
  def destroy
  end
  
  private
  
  def post_params
    params.require(:post).permit(:item_name, :purchased_at, :produced_by, :review, :rate)
  end
  
end
