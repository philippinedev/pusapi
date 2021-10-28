require 'rails_helper'

RSpec.describe PasswordResetInitiator, type: :model do
  let(:email) { nil }
  let(:inputs) do
    {
      email: email
    }
  end
  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:errors) { outcome.errors }

  it 'raises error' do
    expect { outcome! }.to raise_error ActiveInteraction::InvalidInteractionError
  end

  context 'missing email' do
    let(:email) { "missing@example.com" }

    it 'validates' do
      expect { outcome! }.to raise_error ActiveInteraction::InvalidInteractionError
      expect(errors[:email]).to include "not found"
      expect(errors[:status]).to include 404
    end
  end

  context 'valid email' do
    let(:email) { "john@example.com" }
    let!(:user) { create(:admin_user, email: email) }
    let(:token) { "token" }
    let(:mailer) { double }

    before do
      allow(SecureRandom).to receive(:alphanumeric).and_return(token)
      allow(PasswordResetMailer).to receive(:with).and_return(mailer)
      allow(mailer).to receive_message_chain("initiate.deliver")
    end

    after do
      outcome
    end

    it 'invokes user reset password initiation' do
      expect_any_instance_of(AdminUser).to receive(:initiate_reset_password).with(token)
    end

    it 'invokes sending of PasswordResetMailer' do
      expect(PasswordResetMailer).to receive(:with)
        .with(user: user, token: token)
    end
  end
end

