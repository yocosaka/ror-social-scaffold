class FriendshipsController < ApplicationController
  def create
    # puts "output** #{current_user.name}"
    invitee = User.find(params[:invitee_id])
    current_user.requests_for_friendship(invitee)
    redirect_to user_path(params[:invitee_id])
  end

  def update
    case params[:status]
    when 'accept'
      current_user.approve_request(Friendship.find(params[:id]).inviter)
    when 'reject'
      current_user.reject_request(Friendship.find(params[:id]).inviter)
    end
    redirect_to users_path
  end
end