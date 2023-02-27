class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  
  def self.search_posts_for(content, method)
    if method == 'perfect'
      tags = Tag.where(tag_name: content)
    end
    
    return tags.inject(init = []) {|result, tag| result + tag.posts}
  end
  
end
