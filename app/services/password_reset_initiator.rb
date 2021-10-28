class PasswordResetInitiator < PasswordReset
  TOKEN_LENGTH = 20

  string :email

  def execute
    return if user.nil?

    user.initiate_reset_password(token)
    password_reset_email.send(deliver)
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

  def deliver
    return :deliver if Rails.env.development?
    return :deliver if Rails.env.test?

    :deliver_later
  end
end
