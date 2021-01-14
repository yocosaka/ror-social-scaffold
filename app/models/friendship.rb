class Friendship < ApplicationRecord
  after_update(:create_mutual_friendship)
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  def create_mutual_friendship
    fs = Friendship.find(id)
    Friendship.create(inviter_id: fs.invitee_id, invitee_id: fs.inviter_id, accepted: true) if fs
  end
end
