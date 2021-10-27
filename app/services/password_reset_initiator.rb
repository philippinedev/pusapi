class PasswordResetInitiator < ActiveInteraction::Base
  string :email

  def execute
    user.initiate_reset_password(token)
    password_reset_email.deliver
  end

  private

  def user
    @user ||= AdminUser.find_by(email: email).tap do |user|
      errors.add(:base, "admin email not found") if user.nil?
    end
  end

  def password_reset_email
    PasswordResetMailer
      .with(user: user, password: token)
      .initiate
  end

  def token
    @token ||= SecureRandom.alphanumeric(20)
  end
end
