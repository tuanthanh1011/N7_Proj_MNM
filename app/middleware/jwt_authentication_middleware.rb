class JwtAuthenticationMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
        puts "HIHI"
        request = ActionDispatch::Request.new(env)
  
        # Lấy token từ header Authorization
        authorization_header = request.headers['Authorization']

        # Kiểm tra xem có Authorization header không và định dạng là "Bearer <token>"
        if authorization_header.present? && authorization_header.start_with?('Bearer ')
        jwt_token = authorization_header.split(' ')[1]
            puts jwt_token
        else
        # Xử lý trường hợp không có hoặc không đúng định dạng
        end
  
      @app.call(env)
    end
  end
  