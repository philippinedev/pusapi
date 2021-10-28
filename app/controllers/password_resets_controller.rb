class PasswordResetsController < ApplicationController
  # STEP 1 - Accept email
  def create
    @outcome = PasswordResetInitiator.run(email: params[:email])
    render_json
  end

  # STEP 2 - Validate email and token
  def show
    @outcome = PasswordResetValidator.run(
      email: params[:email],
      token: params[:token]
    )
    render_json
  end

  # STEP 3 - Save new password after validating email and token
  def update
    @outcome = PasswordResetUpdater.run(
      email: params[:email],
      token: params[:token],
      password: params[:password]
    )
    render_json
  end
end
