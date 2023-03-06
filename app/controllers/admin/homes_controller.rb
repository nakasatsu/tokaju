class Admin::HomesController < ApplicationController
  def top
    @posts = Post.order(created_at: :desc).page(params[:page])
  end
end
