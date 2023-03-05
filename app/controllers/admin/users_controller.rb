class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def unsubscribe
  end
  
  def destroy
  end
  
end
