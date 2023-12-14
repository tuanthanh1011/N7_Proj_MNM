class ApplicationController < ActionController::API 
  include ActionController::Cookies

  def render_response(message, options = {})
    status = options[:status] || :ok
    response_data = { message: message }
    response_data[:data] = options[:data] if options[:data].present?
    response_data[:errors] = options[:errors] if options[:errors].present?

    render json: response_data, status: status
  end
end
