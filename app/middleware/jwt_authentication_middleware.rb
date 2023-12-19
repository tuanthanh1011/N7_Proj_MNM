  class JwtAuthenticationMiddleware
  def initialize(app)
    @app = app
    @ignored_endpoints = [
      { path: '/api/v1/auth/login', methods: [:post] },
      { path: '/api/v1/students/search', methods: [:post] },
      { path: '/api/v1/admin/students', methods: [:get] },
      { path: '/api/v1/admin/students/volunteer', methods: [:get] },
      { path: '/api/v1/interviews', methods: [:get] },
      { path: %r{/api/v1/students/.+}, methods: [:get] },
      { path: '/api/v1/student_interview', methods: [:post] },
      { path: '/api/v1/student_interview', methods: [:get] },
      { path: '/api/v1/admin/interviews', methods: [:get] },
      { path: '/api/v1/admin/student_interview', methods: [:patch] },
      { path: '/api/v1/admin/student_interview', methods: [:get] },
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

        # Kiểm tra có tồn tại sinh viên theo mã trong token không
        unless StudentService.findStudentByAccout(student_account['AccountCode'])
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

  def ignored_endpoint?(path, method)
    @ignored_endpoints.any? do |endpoint|
      path_matches?(endpoint[:path], path) && endpoint[:methods].include?(method.to_s.downcase.to_sym)
    end
  end

  def path_matches?(pattern, path)
    Regexp.new("^#{pattern}$").match?(path)
  end

  # Hàm xử lý response khi token không hợp lệ
  def unauthorized_response
    [401, { 'Content-Type' => 'application/json' }, [{ message: 'Bạn không có quyền truy cập vào trang này' }.to_json]]
  end
end
