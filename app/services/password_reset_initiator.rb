class PasswordResetInitiator < PasswordReset
  TOKEN_LENGTH = 20

  string :email

  def execute
    return if user.nil?

    user.initiate_reset_password(token)
    password_reset_email.deliver
  end

  private

  def password_reset_email
    PasswordResetMailer
      .with(user: user, token: token)
      .initiate
  end

  def token
    @token ||= SecureRandom.alphanumeric(TOKEN_LENGTH)
  end
end
