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
    # 以下、閲覧履歴を保存するためのコード
    new_history = BrowsingHistory.new
    new_history.user_id = current_user.id
    new_history.post_id = @post.id
    # 同一記事の重複チェック、重複時は古い記事を削除
    if current_user.browsing_histories.exists?(post_id: params[:id])
      old_history = current_user.browsing_histories.find_by(post_id: params[:id])
      old_history.destroy
    end
    new_history.save
    # 同一ユーザーの閲覧履歴件数が上限を超えた場合の処理
    histories_stock_limit = 10
    histories = current_user.browsing_histories.all
    if histories.count > histories_stock_limit
      histories[0].destroy
    end
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
    # 元々の画像IDを記憶しておく
    image_blob_id = @post.image.blob_id
    tag_list = params[:post][:tag_name].split(/[[:blank:]]+/)
    if tag_list == []
      tag = Tag.new()
      tag.tag_name = ""
      tag.save
      # @postに元々の画像データをセットする
      # ActiveStorageの場合はattachメソッドで画像をセットする
      @post.image.attach(ActiveStorage::Blob.find(image_blob_id))
      flash[:notice] = "タグが入力されていません。"
      render :edit
    elsif @post.update(post_params)
      @post.save_tags(tag_list)
      flash[:notice] = "レビューが更新されました。"
      redirect_to post_path(@post)
    else
      @post.image.attach(ActiveStorage::Blob.find(image_blob_id))
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
