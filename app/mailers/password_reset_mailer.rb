class PasswordResetMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def initiate
    @url      = 'http://example.com/login'

    @user     = params[:user]
    @password = params[:password]

    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
