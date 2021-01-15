class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :invitations_i_got, foreign_key: :invitee_id, class_name: 'Friendship', dependent: :destroy
  has_many :who_invited_me, through: :invitations_i_got, source: :inviter, dependent: :destroy

  has_many :invitations_i_sent, foreign_key: :inviter_id, class_name: 'Friendship', dependent: :destroy
  has_many :who_i_invited, through: :invitations_i_sent, source: :invitee, dependent: :destroy

  def requests_for_friendship(user)
    return false if who_i_invited.include?(user) || who_invited_me.include?(user)

    who_i_invited << user
  end

  def approve_request(user)
    friend_to_be = invitations_i_got.where(inviter_id: user.id).first
    friend_to_be.update(accepted: true)
  end

  def reject_request(user)
    friend_to_be = invitations_i_got.where(inviter_id: user.id).first
    friend_to_be.destroy
  end

  def friends
    User.where(id: invitations_i_got.where(accepted: true).pluck(:inviter_id))
  end

  # Check if we are already friends or not which means both of us were accepted each
  def friend?(user)
    friends.include?(user)
  end

  def pending_i_got?(user)
    pending_requests_i_got.include?(user)
  end

  def pending_i_sent?(user)
    pending_requests_i_sent.include?(user)
  end

  # People who haven't accepted my request yet
  def pending_requests_i_sent
    invitations_i_sent.map { |friendship| friendship.invitee unless friendship.accepted }
  end

  # People who I haven't accepted their request yet
  def pending_requests_i_got
    invitations_i_got.map { |friendship| friendship.inviter unless friendship.accepted }
  end
end
