class ChangeColumnAcceptedForFriendships < ActiveRecord::Migration[5.2]
  def change
    change_column_default :friendships, :accepted, 'pending'
  end
end
