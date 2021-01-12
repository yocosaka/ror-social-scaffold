class ChangeColumnTypeAcceptedForFriendships < ActiveRecord::Migration[5.2]
  def change
    change_column :friendships, :accepted, :string
  end
end
