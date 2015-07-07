class User < ActiveRecord::Base
  has_many :notes
  has_many :comments

  has_many :user_follows
  has_many :is_followings, class_name: "UserFollow", foreign_key: :is_following_id

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  def follow_user(user_id_to_follow)
    new_follow = is_followings.new(user_id: user_id_to_follow)
    new_follow.delete unless new_follow.save
    new_follow
  end

  def unfollow_user(user_id_to_unfollow)
    user_follow = is_followings.find_by_user_id(user_id_to_unfollow)
    user_follow.destroy
  end

  def is_followed_by
    User.find(is_followed_by_ids)
  end

  def is_followed_by_ids
    user_follows.pluck(:is_following_id)
  end

  def is_following
    User.find(is_following_ids)
  end

  def is_following_ids
    is_followings.pluck(:user_id)
  end

  def has_new_followers?
    user_follows.pluck(:notification_flag).include?(false)
  end
  
end