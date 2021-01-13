class FriendshipsController < ApplicationController
  def create
    # puts "output** #{current_user.name}"
    invitee = User.find(params[:invitee_id])
    current_user.requests_for_friendship(invitee)
    redirect_to user_path(params[:invitee_id])
  end

  def update
    current_user.approve_request(Friendship.find(params[:id]).inviter)

    redirect_to users_path
  end

  def destroy
    current_user.reject_request(Friendship.find(params[:id]).inviter)

    redirect_to users_path
  end
end
