class PasswordResetsController < ApplicationController
  # STEP 1 - Accept email
  def create
    @outcome = PasswordResetInitiator.run(email: params[:email])
    render_json
  end

  # STEP 2 - Validate email and token
  def show
    token_check
    render_json
  end

  # STEP 3 - Save new password after validating email and token
  def update
    if token_check.valid?
      @outcome = PasswordResetUpdater.run(
        email: params[:email],
        token: params[:token],
        password: params[:password]
      )
    end
    render_json
  end

  private

  def token_check
    @outcome = PasswordResetValidator.run(
      email: params[:email],
      token: params[:token]
    )
  end
end
