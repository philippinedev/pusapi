class PasswordResetValidator < ApplicationService
  EXPIRATION_HOURS = 24

  string :email
  string :token

  def execute
    user.present? \
      && not_expired? \
      && token_matched?
  end

  private

  def not_expired?
    elapsed.minutes < EXPIRATION_HOURS.hours.minutes
  end

  def elapsed
    Time.now - user.reset_password_sent_at
  end

  def token_matched?
    user.reset_password_token_matched? token
  end
end

