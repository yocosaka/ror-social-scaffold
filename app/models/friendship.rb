class Friendship < ApplicationRecord
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'
end

# user1 = User.create(name: 'user1', email: 'user1@gmail.com', password: '123456');
# user2 = User.create(name: 'user2', email: 'user2@gmail.com', password: '123456');
# user3 = User.create(name: 'user3', email: 'user3@gmail.com', password: '123456');

# user1 = User.first;
# user2 = User.second;
# user3 = User.last;