require 'jwt'
require "./app/services/student_service.rb"

class JwtAuthenticationMiddleware
  def initialize(app)
    @app = app
    @ignored_paths = [
        '/api/v1/auth/login',
        '/api/v1/auth/refresh',
        '/api/v1/students/search',
        '/api/v1/students',
        '/api/v1/interviews',
        '/api/v1/student_interview',
    ]
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    # Kiểm tra xem đường dẫn của yêu cầu có nằm trong danh sách bỏ qua không
    if ignored_path?(request.path)
      return @app.call(env)
    end

    begin
      # Lấy token từ header Authorization
      authorization_header = request.headers['Authorization']

      puts "HIHI2"
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

        # Kiểm tra có tồn tại sinh viên theo mã trong token không
        unless StudentService.findStudentById(student_account['StudentCode'])
            # Xử lý token không hợp lệ
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
  def ignored_path?(path)
    @ignored_paths.include?(path)
  end

  # Hàm xử lý response khi token không hợp lệ
  def unauthorized_response
    [401, { 'Content-Type' => 'application/json' }, [{ message: 'Bạn không có quyền truy cập vào trang này' }.to_json]]
  end

end
