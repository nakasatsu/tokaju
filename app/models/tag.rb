class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  
  validates :tag_name, presence: true
  
  def self.search_posts_for(content, method)
    if method == 'perfect'
      tags = Tag.where(tag_name: content)
    # elsif method == 'forward'
      # tags = Tag.where('tag_name LIKE ?', content + '%')
    # elsif method == 'backward'
      # tags = Tag.where('tag_name LIKE ?', '%' + content)
    # else
      # tags = Tag.where('tag_name LIKE ?', '%' + content + '%')
    end
    # tagに紐づくpostの情報を配列で取得
    return tags.inject(init = []) {|result, tag| result + tag.posts}
    ##.idsは後から追加し、postのidのみを取得するように変更
    # return tags.inject(init = []) {|result, tag| result + tag.posts.ids}
  end
  
end
