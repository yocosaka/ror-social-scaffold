class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.boolean :accepted, default: false
      t.references :invitee, foreign_key: { to_table: :users }
      t.references :inviter, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
