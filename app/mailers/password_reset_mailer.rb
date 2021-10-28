class PasswordResetMailer < ApplicationMailer
  DEFAULT_FRONTEND_URL = 'http://frontend.loc/'

  default from: 'notifications@example.com'

  def initiate
    @user = params[:user]
    @frontend_reset_url = frontend_reset_url

    mail(to: @user.email, subject: "Forgot Password")
  end

  private

  def frontend_reset_url
    "#{frontend_root_url}password-reset/?token=#{params[:token]}"
  end

  def frontend_root_url
    ENV.fetch("FRONTEND_ROOT_URL") { DEFAULT_FRONTEND_URL }
  end
end
