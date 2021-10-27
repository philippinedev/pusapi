class PasswordResetsController < ApplicationController
  def show
    @outcome = PasswordResetValidator.run(
      email: params[:email],
      token: params[:token]
    )

    render json: { success: success }, status: status
  end

  def create
    render json: {}
  end

  private

  def success
    @outcome.valid?
  end

  def status
    @outcome.valid? ? 200 : 404
  end
end
