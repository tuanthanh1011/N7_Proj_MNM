class Api::V1::AuthController < ApplicationController

  # Xử lý đăng nhập
  def login
    # Lấy username và password gửi trong request
    username = params[:username]
    password = params[:password]

    # Gọi hàm xử lý đăng nhập
    result = AuthService.loginService(username, password, response)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end
 
    render_response(result[:message], data: result[:data], status: result[:status])
  end

  # Đăng xuất
  def logout
    response.delete_cookie(:refresh_token, path: "/")
    render_response("Đăng xuất thành công", status: 200)
  end

  # Tạo token mới khi access token hết hạn
  def refresh
    # Lấy token từ cookies trong header
    refresh_token_cookie = cookies[:refresh_token]

    result = AuthService.refreshTokenService(refresh_token_cookie, response)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end
 
    render_response(result[:message], data: result[:data], status: result[:status])
  end
end
