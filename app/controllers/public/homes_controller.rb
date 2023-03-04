class Public::HomesController < ApplicationController
  def top
    # 最新の投稿を降順に表示
    @posts = Post.order(created_at: :desc).first(5)
  end
end
