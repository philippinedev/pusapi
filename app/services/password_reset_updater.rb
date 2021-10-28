require 'bcrypt'

class PasswordResetUpdater < ApplicationService
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
end

