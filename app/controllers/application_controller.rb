class ApplicationController < ActionController::API 
  include ActionController::Cookies
  def render_response(message, data = nil, errors = nil)
    response_data = { message: message }
    response_data[:data] = data if data.present?
    response_data[:message] = errors if errors.present?

    render json: response_data
  end
end
