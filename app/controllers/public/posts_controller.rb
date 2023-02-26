class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split(',')
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
  end
  
  private
  
  def post_params
    params.require(:post).permit(:item_name, :purchased_at, :produced_by, :review, :rate, :image)
  end
  
end
