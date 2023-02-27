class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'tag'
      @records = Tag.search_posts_for(@content, @method)
    end
  end
end
