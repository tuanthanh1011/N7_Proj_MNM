require 'jwt'

class Api::V1::AuthController < ApplicationController
  def login
    hmac_secret = 'TuanThanh'
    username = params[:username]
    password = params[:password]

    account = Auth.find_by(Username: username)

    if account
      payload = { 
        Username: account.Username,
        AccountCode: account.AccountCode,
        Role: account.Role
      }

      expiration_time = 1.hour.from_now.to_i
      access_token = JWT.encode payload, hmac_secret, 'HS256', exp: expiration_time

      response.set_cookie(
        :access_token, {
          value: access_token,
          expires: 1.hour.from_now,
          httponly: true,
          secure: false
        }
      )

      render_response("Đăng nhập thành công", {
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

  def logout
    response.delete_cookie(:access_token)
    render_response("Đăng xuất thành công")
  end

  def refresh
    
  end

  def check_cookie
    access_token_cookie = cookies[:accessToken]

    if access_token_cookie.present?
      render_response("Cookie đã được đặt", { accessToken: access_token_cookie })
    else
      render_response("Cookie không tồn tại")
    end
  end

end
