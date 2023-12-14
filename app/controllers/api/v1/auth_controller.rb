require 'jwt'

class Api::V1::AuthController < ApplicationController

  # Tạo access token
  def generateAccessToken (payload)
    hmac_secret_access = 'TuanThanh'
    expiration_time = 1.hour.from_now.to_i
    access_token = JWT.encode payload, hmac_secret_access, 'HS256', exp: expiration_time
    return access_token
  end

  #Tạo refresh token
  def generateRefreshToken (payload)
    hmac_secret_refresh = 'TuanThanhDayNe'
    expiration_time = 1.year.from_now.to_i
    refresh_token = JWT.encode payload, hmac_secret_refresh, 'HS256', exp: expiration_time
    return refresh_token
  end

  # Xử lý đăng nhập
  def login
    # Lấy username và password gửi trong request
    username = params[:username]
    password = params[:password]

    #Kiểm tra thông tin tài khoản
    account = Auth.find_by(Username: username, Password: password)

    if account
      # Dữ liệu tạo token
      payload = { 
        Username: account.Username,
        AccountCode: account.AccountCode,
        Role: account.Role
      }

      #Tạo access token và refresh token
      access_token = generateAccessToken(payload)
      refresh_token = generateRefreshToken(payload)

      # Set token vào cookie
      response.set_cookie(
        :refresh_token, {
          value: refresh_token,
          expires: 1.year.from_now,
          secure: true,
          httpOnly: true,
          same_site: :none
        }
      )

      render_response("Đăng nhập thành công", data: {
        accessToken: access_token,
        account: {
          Username: account.Username,
          AccountCode: account.AccountCode,
          Role: account.Role
        } 
      })

    else  
      render_response("Tài khoản hoặc mật khẩu không chính xác")
    end
  end

  #Đăng xuất
  def logout
    response.delete_cookie(:refresh_token)
    render_response("Đăng xuất thành công")
  end

  # Tạo token mới khi access token hết hạn
  def refresh
    hmac_secret_refresh = 'TuanThanhDayNe'

    # Lấy token từ cookies trong header
    refresh_token_cookie = cookies[:refresh_token]

    # Kiểm tra sự tồn tại của refresh token
    unless refresh_token_cookie
      render_response("Bạn không có quyền truy cập trang này", status: :unauthorized)
      return
    end
  
    begin
      # Giải mã
      decoded_token = JWT.decode refresh_token_cookie, hmac_secret_refresh, true, { algorithm: 'HS256' }
    
      # Lấy data
      account = decoded_token[0]
    
      newAccessToken = generateAccessToken(account)
      newRefreshToken = generateRefreshToken(account)
    
      response.set_cookie(
        :refresh_token, {
          value: newRefreshToken,
          expires: 1.year.from_now,
          secure: true,
          httpOnly: true,
          same_site: :none
        }
      )
      render_response("Tạo mới access token", data: { accessToken: newAccessToken })
    rescue JWT::DecodeError => e
      # Xử lý lỗi khi giải mã thất bại
      render_response("Lỗi khi giải mã refresh token: #{e.message}", status: :unprocessable_entity)
    end

  end
  
end
