require 'bcrypt'

class PasswordResetUpdater < ActiveInteraction::Base
  include BCrypt

  string :email
  string :token
  string :password

  def execute
    ActiveRecord::Base.transaction do
      set_new_password
      update_user!
    end
  end

  private

  def update_user!
    user.save!
    user.update!(
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end

  def set_new_password
    user.password = password
  end

  def user
    @user ||= AdminUser.find_by(email: email).tap do |user|
      if user.nil?
        errors.add(:email, "not found")
        errors.add(:status, 404)
      end
    end
  end
end

