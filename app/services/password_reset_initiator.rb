class PasswordResetInitiator < ActiveInteraction::Base
  TOKEN_LENGTH = 20

  string :email

  def execute
    return if user.nil?

    user.initiate_reset_password(token)
    password_reset_email.deliver
  end

  private

  def user
    @user ||= AdminUser.find_by(email: email).tap do |user|
      if user.nil?
        errors.add(:email, "not found")
        errors.add(:status, 404)
      end
    end
  end

  def password_reset_email
    PasswordResetMailer
      .with(user: user, password: token)
      .initiate
  end

  def token
    @token ||= SecureRandom.alphanumeric(TOKEN_LENGTH)
  end
end
