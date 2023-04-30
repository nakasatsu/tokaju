class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = post.id
    unless @comment.save
      flash[:notice] = "コメントを入力してください"
      @post = Post.find(params[:post_id])
      @post_comment = PostComment.new
      render template: "public/posts/show"
    end
    # if comment.save
    #   redirect_to post_path(post.id)
    # else
    #   flash[:notice] = "コメントを入力してください"
    #   @post = Post.find(params[:post_id])
    #   @post_comment = PostComment.new
    #   render template: "public/posts/show"
    # end
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
    # PostComment.find(params[:id]).destroy
    # redirect_to post_path(params[:post_id])
  end
  
  private
  
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
