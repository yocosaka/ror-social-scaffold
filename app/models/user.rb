class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :invitations_i_got, foreign_key: :invitee_id, class_name: 'Friendship'
  has_many :who_invited_me, through: :invitations_i_got, source: :inviter

  has_many :invitations_i_sent, foreign_key: :inviter_id, class_name: 'Friendship'
  has_many :who_i_invited, through: :invitations_i_sent, source: :invitee

  def requests_for_friendship(user)
    return false if who_i_invited.include?(user) || who_invited_me.include?(user)

    who_i_invited << user
  end

  def approve_request(user)
    friend_to_be = invitations_i_got.where(inviter_id: user.id).first
    friend_to_be.accepted = true
    friend_to_be.save
  end

  def friends
    friends = invitations_i_got.map { |friendship| friendship.inviter if friendship.accepted }
    friends.concat(invitations_i_sent.map { |friendship| friendship.invitee if friendship.accepted })
    friends.compact
  end
  
  # Check if we are already friends or not which means both of us were accepted each
  def friend?(user)
    friends.include?(user)
  end

  # People who haven't accepted my request yet
  def pending_requests_i_sent
    invitations_i_sent.map { |friendship| friendship.invitee unless friendship.accepted }
  end

  # People who I haven't accepted their request yet
  def pending_requests_i_got
    invitations_i_got.map { |friendship| friendship.inviter unless friendship.accepted }
  end


  # # User has many friendships & inverse friendships as a friend
  # has_many :friendships # as a user
  # has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :friend_id # as a friend

  # # ============== NOTE START ==============
  # # What is friendship?
  # # => People who I sent requests including both accepted and not accepted yet

  # # What is inverse_friendship?
  # # => People who I recieve their requests including both accepted and not accepted yet

  # # What is friends?
  # # => People both who I accepted their requests and who accepted my requests
  # # Note: It doesn't include in case that either user doesn't accept
  # # ============== NOTE END ==============

  # # Define User's friends =>
  # # => People both who I accepted their requests and who accepted my requests
  # def friends
  #   # Collect the friend_ids if my request was accepted as a user
  #   friends_array = friendships.map { |friendship| friendship.friend if friendship.accepted }
  #   # Collect the user_ids if I accepted the other's request as a freind
  #   friends_array.concat(inverse_friendships.map { |friendship| friendship.user if friendship.accepted })
  #   # Exclude User myself
  #   friends_array.compact
  # end

  # # People who haven't accepted my request yet
  # def pending_friends
  #   friendships.map { |friendship| friendship.friend unless friendship.accepted }.compact
  # end

  # # People who I haven't accepted their request yet
  # def pending_requests
  #   inverse_friendships.map { |friendship| friendship.user unless friendship.accepted }.compact
  # end

  # # Change the status of pending_requests from false to TRUE in order to build our friendships
  # def accept_request(user)
  #   friendship = inverse_friendships.find { |fs| fs.user == user }
  #   friendship.accepted = true
  #   friendship.save
  # end

  # # Check if we are already friends or not which means both of us were accepted each other's request
  # def friend?(user)
  #   friends.include?(user)
  # end
end
