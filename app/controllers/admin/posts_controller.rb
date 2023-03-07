class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_user_path(@post.user), notice: '投稿を削除しました。'
  end 
  
end
