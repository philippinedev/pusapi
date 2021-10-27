require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  let(:token) { "token" }

  describe '#initiate_reset_password' do
    let(:token) { "token" }
    let(:encrypted_token) { "encrypted-token" }
    let(:sent_at) { DateTime.current }
    let!(:user) { create(:admin_user) }

    subject { user.initiate_reset_password(token) }

    before do
      allow(BCrypt::Password)
        .to receive(:create).with(token)
        .and_return(encrypted_token)

      allow(DateTime)
        .to receive(:current)
        .and_return(sent_at)
    end

    it 'successfully updates reset password columns' do
      expect { subject }.to change { AdminUser.where(
        reset_password_token: encrypted_token,
        reset_password_sent_at: sent_at
      ).count }.by(1)
    end
  end

  describe '#reset_password_token_matched?' do
    let(:encrypted_token) { BCrypt::Password.create(token) }
    let(:user) { create(:admin_user, reset_password_token: encrypted_token) }

    subject { user.reset_password_token_matched?(token) }

    it 'returns true' do
      expect(subject).to be true
    end

    context 'invalid token' do
      let(:wrong_token) { "atoken" }

      subject { user.reset_password_token_matched?(wrong_token) }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end

