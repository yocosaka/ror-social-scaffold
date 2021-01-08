class AddUserFriendToFriendships < ActiveRecord::Migration[5.2]
  def change
    add_reference :friendships, :user, foreign_key: true
    add_reference :friendships, :friend, references: :users, foreign_key: { to_table: :users }
  end
end
