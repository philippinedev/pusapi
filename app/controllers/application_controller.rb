class ApplicationController < ActionController::API
  private

  def render_json
    render json: response_data, status: status
  end

  def response_data
    {
      success: success,
      error: error,
      message: message
    }
  end

  def success
    @outcome.valid?
  end

  def error
    return if @outcome.errors.messages.except(:status).blank?

    @outcome.errors.full_messages.to_sentence.gsub(/ and Status \d{3}/, "")
  end

  def message
    @outcome.valid? ? "Success" : "Failure"
  end

  def status
    return @outcome.errors[:status].last if @outcome.errors[:status].any?
    return 422 if @outcome.errors.any?

    200
  end
end
