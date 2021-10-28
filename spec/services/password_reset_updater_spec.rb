require 'rails_helper'

RSpec.describe PasswordResetUpdater, type: :model do
  let(:email) { nil }
  let(:token) { nil }
  let(:password) { nil }

  subject do
    described_class.run!(
      email: email,
      token: token,
      password: password,
    )
  end

  it 'raises error' do
    expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError
  end

  context 'with valid params' do
    let(:email) { "john@example.com" }
    let(:token) { "token" }
    let(:password) { 'AN@#$password' }
    let(:encrypted_token) { "encrypted-token" }
    let(:sent_at) { DateTime.current }

    let!(:user) do
      create(:admin_user,
             email: email,
             reset_password_token: encrypted_token,
             reset_password_sent_at: sent_at
      )
    end

    it 'updates password digest' do
      expect { subject }.to change { AdminUser.where(
        reset_password_token: nil,
        reset_password_sent_at: nil
      ).count }.by(1)
    end

    it 'authenticates new password' do
      subject
      expect(BCrypt::Password.new(user.reload.password_digest) == password).to be true
    end
  end
end
