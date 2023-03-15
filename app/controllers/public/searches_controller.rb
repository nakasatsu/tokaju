class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'tag'
        ## タグに紐づく投稿のidを配列で取得し@recordsに格納
      # tagに紐づくpostの情報を配列で取得
      @initRecords = Tag.search_posts_for(@content, @method)
        ## @recordsに合致するpostを取得し@resultsに格納（ページネーションするため追記）
      @records = Post.where(id: @initRecords).page(params[:page])
        ## ビューで「全◯件」と表示するために@recordsと@resultsを区別している
    end
    if @records != [] #@recordsは配列なのでnilではなく[]で表す
      # filterに渡すための変数
      @posts = @records
    end
  end
  
  def filter
    if params[:post]
      @content = params[:post][:content]
      @method = params[:post][:method]    
      @rate = params[:post][:rate]
    else 
      @content = params[:content]
      @method = params[:method]
      @rate = params[:rate]
    end
    @records = Tag.search_posts_for(@content, @method)
    #@records = Tag.where(tag_name:@ccontent)
    # 取得したpostの情報（配列型）から、rateが選択されたものと合致するpostのみを選び出す
    @initRecords = @records.select { |record| record.rate == @rate.to_i }
    ## @recordsに合致するpostを取得し@resultsに格納（ページネーションするため追記）
    @records = Post.where(id: @initRecords,rate: @rate).page(params[:page])
    #@records = @records.where({}).page(params[:page])
      # @results = Post.where(id: @records).page(params[:page])
    render :search
  end
  
end
