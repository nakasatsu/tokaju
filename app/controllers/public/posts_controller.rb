class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  
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
    if tag_list == []
      tag = Tag.new()
      tag.tag_name = ""
      tag.save
      flash[:notice] = "タグが入力されていません。"
      render :new
    elsif @post.save
      @post.save_tags(tag_list)
      flash[:notice] = "レビューが投稿されました！"
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
    # カラの配列を用意
    tags = []
    # @postに紐づくtagを取得し配列[]に格納
    @post.tags.each do |tag|
      tags << tag.tag_name
    end
    # tags => ["test1", "test2"]
    @tags = tags.join(' ') # "test1 test2"
    # 配列を一つの文字列に加工し、valueに渡す。
  end
  
  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(/[[:blank:]]+/)
    if tag_list == []
      tag = Tag.new()
      tag.tag_name = ""
      tag.save
      flash[:notice] = "タグが入力されていません。"
      render :new
    elsif @post.update(post_params)
      @post.save_tags(tag_list)
      flash[:notice] = "レビューが更新されました。"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:item_name, :purchased_at, :produced_by, :review, :rate, :image)
  end
  
  def is_matching_login_user
    # post_id = params[:id].to_i
    post = Post.find(params[:id])
    user_id = post.user_id
    unless user_id == current_user.id
      redirect_to post_path(post), notice: '他のユーザーの投稿編集画面へは遷移できません。'
    end
  end
  
end
