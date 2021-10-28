require "rails_helper"

RSpec.describe PasswordResetMailer, type: :mailer do
  describe "initiate" do
    let(:user) { create(:admin_user) }
    let(:token) { "token" }
    let(:mail) { described_class.with(user: user, token: token).initiate }

    it "renders the headers" do
      expect(mail.subject).to eq("Forgot Password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['notifications@example.com'])
    end

    it "renders the body with reset link" do
      frontend_root_url = ENV.fetch("FRONTEND_ROOT_URL") { PasswordResetMailer::DEFAULT_FRONTEND_URL }
      link = "#{frontend_root_url}password-reset/?token=#{token}"

      expect(mail.body.encoded).to include(link)
    end
  end
end
