class PasswordResetValidator < ActiveInteraction::Base
  string :email
  string :token

  def execute
    user.present? && token_matched?
  end

  private

  def user
    @user ||= AdminUser.find_by(email: email).tap do |user|
      errors.add(:base, "Admin user has no matching email") if user.nil?
    end
  end

  def token_matched?
    user.reset_password_token_matched? token
  end
end

