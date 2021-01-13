require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'testing associations' do
    it { should belong_to(:inviter) }
    it { should belong_to(:invitee) }
  end
end
