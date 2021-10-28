require 'rails_helper'

RSpec.describe PasswordResetValidator, type: :model do
  let(:email) { nil }
  let(:token) { nil }

  subject { described_class.run!(email: email, token: token) }

  it 'raises error' do
    expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError
  end

  context 'valid input' do
    let(:email) { "john@example.com" }
    let(:token) { "timbi" }
    let(:encrypted_token) { nil }
    let(:sent_at) { 1.day.ago }

    let!(:user) do
      create(:admin_user,
             email: email,
             reset_password_token: encrypted_token,
             reset_password_sent_at: sent_at
            )
    end

    context 'expired token' do
      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'not expired token' do
      let(:encrypted_token) { BCrypt::Password.create(token) }
      let(:not_expired_hours) { PasswordResetValidator::EXPIRATION_HOURS - 1 }
      let(:sent_at) { not_expired_hours.hours.ago }

      it 'returns true' do
        expect(subject).to be true
      end
    end
  end
end

