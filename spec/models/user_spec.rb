require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'testing validations' do
    let(:user1) do
      User.new(name: 'user1asldfjalsdjflaskdjflaskdjflaskdjf', email: 'user1@gmail.com', password: '123456')
    end
    it 'validates length of name to be less than 20' do
      expect(user1.valid?).to eq false
    end
  end

  describe 'testing associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:invitations_i_got) }
    it do
      should have_many(:who_invited_me)
        .through(:invitations_i_got)
        .class_name('User')
    end
    it { should have_many(:invitations_i_sent) }
    it do
      should have_many(:who_i_invited)
        .through(:invitations_i_sent)
        .class_name('User')
    end
  end

  describe 'testing instance methods' do
    let(:user1) { User.create(id: 1, name: 'user1', email: 'user1@gmail.com', password: '123456') }
    let(:user2) { User.create(id: 2, name: 'user2', email: 'user2@gmail.com', password: '123456') }

    describe '#requests_for_friendship' do
      it 'makes friendship request to a given user' do
        user1.requests_for_friendship(user2)
        expect(Friendship.where(inviter_id: 1, invitee_id: 2)).not_to eq nil
      end

      it 'doesnt make friendship request to pending or already friend' do
        user1.requests_for_friendship(user2)
        expect(user1.requests_for_friendship(user2)).to eq false
      end
    end

    describe '#approve_request' do
      it 'approves pending request sent from a given user' do
        user1.requests_for_friendship(user2)
        user2.approve_request(user1)
        expect(Friendship.where(inviter_id: 1, invitee_id: 2).take.accepted).to eq true
      end
    end

    describe '#friends' do
      it 'returns friends of a given user' do
        user1.requests_for_friendship(user2)
        user2.approve_request(user1)
        expect(user1.friends).to include user2
      end

      it 'doesnt return users that are not friends' do
        user1.requests_for_friendship(user2)
        expect(user1.friends).not_to include user2
      end
    end

    describe '#friend?' do
      it 'returns true if a given user is a friend' do
        user1.requests_for_friendship(user2)
        user2.approve_request(user1)
        expect(user1.friend?(user2)).to eq true
      end

      it 'returns false if a given user is not a friend' do
        user1.requests_for_friendship(user2)
        expect(user1.friend?(user2)).to eq false
      end
    end

    describe '#pending_requests_i_sent' do
      it 'returns users that has not accepted my request yet' do
        user1.requests_for_friendship(user2)
        expect(user1.pending_requests_i_sent).to include user2
      end
    end

    describe '#pending_requests_i_got' do
      it 'returns users that I have not accepted their requests yet' do
        user2.requests_for_friendship(user1)
        expect(user1.pending_requests_i_got).to include user2
      end
    end
  end
end
