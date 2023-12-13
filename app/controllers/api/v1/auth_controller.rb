require 'jwt'

class Api::V1::AuthController < ApplicationController
  def login
    hmac_secret_access = 'TuanThanh'
    hmac_secret_refresh = 'TuanThanhDayNe'
    username = params[:username]
    password = params[:password]

    account = Auth.find_by(Username: username, Password: password)

    if account
      payload = { 
        Username: account.Username,
        AccountCode: account.AccountCode,
        Role: account.Role
      }

      expiration_time_access = 1.hour.from_now.to_i
      expiration_time_refresh = 1.year.from_now.to_i

      access_token = JWT.encode payload, hmac_secret_access, 'HS256', exp: expiration_time_access
      refresh_token = JWT.encode payload, hmac_secret_refresh, 'HS256', exp: expiration_time_refresh

      response.set_cookie(
        :access_token, {
          value: access_token,
          expires: 1.hour.from_now,
          httponly: true,
          secure: false,
          same_site: :none
        }
      )

      response.set_cookie(
        :refresh_token, {
          value: refresh_token,
          expires: 1.hour.from_now,
          httponly: true,
          secure: false,
          same_site: :none
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
    access_token_cookie = cookies[:accessToken]
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
