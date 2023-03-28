class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, except: [:show]
  before_action :ensure_guest_user, only: [:edit]
  
  def browse
    @user = User.find(params[:id])
    browsing_history = BrowsingHistory.where(user_id: @user.id).pluck(:post_id)
    # @posts = Post.where(id: browsing_history)
    @posts = Post.find(browsing_history)
  end
  
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @posts = Post.where(id: favorites).page(params[:page])
    # @posts = Post.find(favorites)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    # 元々の画像IDを記憶しておく
    image_blob_id = @user.profile_image.blob_id
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      # @userに元々の画像データをセットする
      # ActiveStorageの場合はattachメソッドで画像をセットする
      @user.profile_image.attach(ActiveStorage::Blob.find(image_blob_id))
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name, :introduction, :profile_image)
  end
  
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to user_path(user_id), notice: '他のユーザーの画面へは遷移できません。'
    end
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
  
end
