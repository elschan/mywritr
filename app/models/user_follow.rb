class UserFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :is_following, class_name: "User"

  validates :user_id, presence: true
  validates :is_following_id, presence: true

  validate :not_following_self
  validate :follow_relation_does_not_already_exist

  private

  def not_following_self
    errors.add(:user_id, "user cannot follow self") if user_id == is_following_id
  end

  def follow_relation_does_not_already_exist
    if UserFollow.where(user_id: user.id).pluck(:is_following_id).include?(:is_following_id)
      errors.add(:user_id, "follow relation already exists")
    end
  end

end