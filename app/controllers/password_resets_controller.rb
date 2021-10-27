class PasswordResetsController < ApplicationController
  # STEP 1 - Accept email
  def create
    @outcome = PasswordResetInitiator.run(email: params[:email])

    render json: { success: success }, status: status
  end

  # STEP 2 - Validate email and token
  def show
    @outcome = PasswordResetValidator.run(
      email: params[:email],
      token: params[:token]
    )

    render json: { success: success }, status: status
  end

  # STEP 3 - Save new password after validating email and token
  def update
    @outcome = PasswordResetUpdater.run(
      email: params[:email],
      token: params[:token],
      password: params[:password]
    )

    render json: { success: success }, status: status
  end

  private

  def success
    @outcome.valid?
  end

  def status
    @outcome.valid? ? 200 : 404
  end
end
