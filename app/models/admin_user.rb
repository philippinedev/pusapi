require 'bcrypt'

class AdminUser < ApplicationRecord
  include BCrypt

  def initiate_reset_password(token)
    update(
      reset_password_token: Password.create(token),
      reset_password_sent_at: DateTime.current
    )
  end

  def reset_password_token_matched?(token)
    Password.new(reset_password_token) == token
  end
end

