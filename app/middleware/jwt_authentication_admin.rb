require 'jwt'
require "./app/services/student_service.rb"
require "./app/services/auth_service.rb"

class JwtAuthenticationMiddlewareAdmin
  def initialize(app, options = {})
    @app = app
    @ignored_paths = [
      { path: '/api/v1/auth/login', methods: [:post] },
      { path: '/api/v1/students/search', methods: [:post] },
      { path: '/api/v1/student_interview', methods: [:post] },
      { path: %r{/api/v1/students/.+}, methods: [:get] },
      { path: '/api/v1/auth/logout', methods: [:post] },
    ]
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

     # Kiểm tra xem đường dẫn và phương thức của yêu cầu có nằm trong danh sách bỏ qua không
     if ignored_endpoint?(request.path, request.method)
      return @app.call(env)
    end

    begin
      # Lấy token từ header Authorization
      authorization_header = request.headers['Authorization']

      # Kiểm tra xem có Authorization header không và định dạng là "Bearer <token>"
      if authorization_header.present? && authorization_header.start_with?('Bearer ')
        # Tách chuỗi bỏ ký tự Bearer
        jwt_token = authorization_header.split(' ')[1]

        # Giải mã token
        decoded_token, _header = JWT.decode jwt_token, ENV['JWT_ACCESS_TOKEN_SECRET'], true, { algorithm: 'HS256' }

        # Truy xuất thời hạn hết hạn từ header
        expiration_time = _header['exp']

        if expiration_time && expiration_time < Time.now.to_i
            # Thời hạn hết hạn đã qua, trả về lỗi
            return unauthorized_response
        end

        # Lấy ra data trong token
        student_account = decoded_token

        puts student_account['accountCode']
        # Kiểm tra có tồn tại account admin
        unless AuthService.findAccountById(student_account['accountCode'])
          return unauthorized_response
        end
      else

        # Xử lý token không hợp lệ
        return unauthorized_response
      end
    rescue JWT::DecodeError => e
        # Xử lý token không hợp lệ
        return unauthorized_response
    end

    @app.call(env)
  end

  private

  # Hàm kiểm tra xem đường dẫn có nằm trong danh sách bỏ qua không
  def ignored_endpoint?(path, method)
    @ignored_endpoints.any? { |endpoint| endpoint[:path] == path && endpoint[:methods].include?(method.to_s.downcase.to_sym) }
  end

  # Hàm xử lý response khi token không hợp lệ
  def unauthorized_response
    [401, { 'Content-Type' => 'application/json' }, [{ message: 'Bạn không có quyền truy cập vào trang này' }.to_json]]
  end

end
