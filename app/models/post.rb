class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
  has_one_attached :image
  
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image_food.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  def save_tags(save_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - save_tags
    new_tags = save_tags - current_tags
    
    old_tags.each do |old_tag|
      self.tags.delete Tag.find_by(tag_name: old_tag)
    end
    
    new_tags.each do |new_tag|
      post_tag = Tag.find_or_create_by(tag_name: new_tag)
      self.tags << post_tag
    end
  end   
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
    
end
