class ApplicationController < ActionController::API
  def render_response(status_code, message, data = {})
    render json: { statusCode: status_code, message: message, data: data }
  end
end
