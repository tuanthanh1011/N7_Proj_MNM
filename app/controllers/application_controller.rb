class ApplicationController < ActionController::API 
  include ActionController::Cookies

  def render_response(message, options = {})
    status = options[:status] || :ok
    response_data = { message: message }
    response_data[:data] = options[:data] if options[:data].present?
    
    if options[:errors].present?
      response_data[:errors] = options[:errors]
    elsif options[:object].present? && options[:object].respond_to?(:errors)
      response_data[:errors] = options[:object].errors.full_messages
    end

    render json: response_data, status: status
  end
end