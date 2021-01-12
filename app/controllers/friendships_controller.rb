class FriendshipsController < ApplicationController
    def create
        # puts "output** #{current_user.name}"
        invitee = User.find(params[:invitee_id])
        current_user.requests_for_friendship(invitee)
        redirect_to user_path(params[:invitee_id])
    end

    def update

    end
end
