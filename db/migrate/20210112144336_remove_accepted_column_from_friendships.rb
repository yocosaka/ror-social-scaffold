class RemoveAcceptedColumnFromFriendships < ActiveRecord::Migration[5.2]
  def change
    remove_column :friendships, :accepted
  end
end
