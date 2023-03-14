class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'tag'
        ## タグに紐づく投稿のidを配列で取得し@recordsに格納
      # tagに紐づくpostの情報を配列で取得
      @records = Tag.search_posts_for(@content, @method)
        ## @recordsに合致するpostを取得し@resultsに格納（ページネーションするため追記）
        # @records = Post.where(id: @records).page(params[:page])
        ## ビューで「全◯件」と表示するために@recordsと@resultsを区別している
    end
    if @records != [] #@recordsは配列なのでnilではなく[]で表す
      # filterに渡すための変数
      @posts = @records
    end
  end
  
  def filter
    @content = params[:post][:content]
    @method = params[:post][:method]
    @records = Tag.search_posts_for(@content, @method)
    # 取得したpostの情報（配列型）から、rateが選択されたものと合致するpostのみを選び出す
    @records = @records.select { |record| record.rate == params[:post][:rate].to_i }
      # @results = Post.where(id: @records).page(params[:page])
    render :search
  end
  
end
