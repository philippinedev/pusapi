class PasswordReset < ActiveInteraction::Base
  private

  def user
    @user ||= AdminUser.find_by(email: email).tap do |user|
      if user.nil?
        errors.add(:email, "not found")
        errors.add(:status, 404)
      end
    end
  end
end
