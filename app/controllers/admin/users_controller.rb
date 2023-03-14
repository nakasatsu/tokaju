class Admin::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:unsubscribe, :destroy]
  
  def index
    @users = User.page(params[:page]).per(10)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
  end
  
  def unsubscribe
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
  
  private
  
  def ensure_guest_user
    user = User.find(params[:id])
    if user.name == "guestuser"
      redirect_to admin_users_path, notice: 'ゲストユーザーは削除できません。'
    end
  end
  
end
