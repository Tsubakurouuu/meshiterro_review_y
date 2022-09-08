class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_images, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  
  has_many :followings, through: :relationships, source: :follower
  has_many :followers, through: :reverse_of_relationships, source: :following

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def follow(user_id)
    relationships.create(follower_id: user_id)
  end
  
  def unfollow(user_id)
    relationships.find_by(follower_id: user_id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end
  
  def self.looks(search, word)
    if search == 'perfect_match'
      @user = User.where('name LIKE?', "#{word}")
    elsif search == 'forward_match'
      @user = User.where('name LIKE?', "#{word}%")
    elsif search == 'backword_match'
      @user = User.where('name LIKE?', "%#{word}")
    elsif search == 'partial_match'
      @user = User.where('name LIKE?', "%#{word}%")
    else
      @user = User.all
    end
  end
end
