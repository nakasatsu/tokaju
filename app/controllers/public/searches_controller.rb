class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'tag'
      @records = Tag.search_posts_for(@content, @method)
    end
    if @records != []
      @posts = @records
    end
  end
  
  def filter
    @content = params[:post][:content]
    @method = params[:post][:method]
    @records = Tag.search_posts_for(@content, @method)
    @records = @records.select { |record| record.rate == params[:post][:rate].to_i }
    render :search
  end
  
end
