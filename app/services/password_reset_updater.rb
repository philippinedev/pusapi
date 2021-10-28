require 'bcrypt'

class PasswordResetUpdater < PasswordReset
  include BCrypt

  string :email
  string :token
  string :password

  def execute
    user&.update!(
      password: password,
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end
end
