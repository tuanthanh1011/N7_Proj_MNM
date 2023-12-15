require_relative "boot"
require "rails/all"
require "./app/middleware/jwt_authentication_middleware.rb"
require "./app/middleware/jwt_authentication_admin.rb"
require "./lib/camel_case_convert.rb"

Bundler.require(*Rails.groups)

module BackendMnm
  class Application < Rails::Application
    
   # Trong config/application.rb hoặc trong mô-đun cấu hình
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # config middleware authen author
    config.middleware.use JwtAuthenticationMiddleware
    config.middleware.use JwtAuthenticationMiddlewareAdmin

    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.api_only = true
  end
end
