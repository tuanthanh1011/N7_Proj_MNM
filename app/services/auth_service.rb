require 'jwt'
class AuthService

  def self.findAccountById (accountCode)
    account = Auth.find_by(AccountCode: accountCode, Role: true)
    if account
      return true
    else
      return false
    end
  end

  # Hàm tạo access token
   def self.generateAccessToken (payload)
    expiration_time = 1.hour.from_now.to_i
    access_token = JWT.encode payload, ENV['JWT_ACCESS_TOKEN_SECRET'], 'HS256', exp: expiration_time
    return access_token
  end

  #Tạo refresh token
  def self.generateRefreshToken (payload)
    expiration_time = 1.year.from_now.to_i
    refresh_token = JWT.encode payload, ENV['JWT_REFRESH_TOKEN_SECRET'], 'HS256', exp: expiration_time
    return refresh_token
  end

  # Hàm login
  def self.loginService (username, password, response)

    #Kiểm tra thông tin tài khoản
    account = Auth.find_by(Username: username, Password: password)
    
    if account
      # Lấy thông tin student tương ứng account code
      student = Student.find_by(AccountCode: account.AccountCode)

      # Dữ liệu tạo token
      payload = { 
        userName: account.Username,
        accountCode: account.AccountCode,
        studentCode: student&.StudentCode,
        name: student&.StudentName || "admin",
        role: account.Role
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
          same_site: :none,
          path: "/"
        }
      )

      # Trả về dữ liệu
      return { 
        success: true, 
        data: {
          accessToken: access_token,
          account: {
            userName: account.Username,
            accountCode: account.AccountCode,
            studentCode: student&.StudentCode,
            name: student&.StudentName || "admin",
            role: account.Role
          }
        },
        message: "Đăng nhập thành công",
        status: 200
      }
    else  
      return { success: false, message: "Tài khoản hoặc mật khẩu không chính xác", status: 401}
    end
  end

  # Hàm tạo token mới khi access token hết hạn
  def self.refreshTokenService (refreshToken, response)

    puts refreshToken
    # Kiểm tra sự tồn tại của refresh token
    unless refreshToken
      return { success: false, message: "Bạn không có quyền truy cập trang này", status: 401 }
    end
  
    begin
      # Giải mã
      decoded_token = JWT.decode refreshToken, ENV['JWT_REFRESH_TOKEN_SECRET'], true, { algorithm: 'HS256' }
    
      # Lấy data
      account = decoded_token[0]
    
      # Tạo mới access token và refresh token
      newAccessToken = generateAccessToken(account)
      newRefreshToken = generateRefreshToken(account)
    
      # Lưu refresh token mới vào cookie
      response.set_cookie(
        :refresh_token, {
          value: newRefreshToken,
          expires: 1.year.from_now,
          secure: true,
          httpOnly: true,
          same_site: :none,
          path: "/"
        }
      )

      return { success: true, message: "Tạo mới access token thành công", data: { accessToken: newAccessToken } }

    # Xử lý lỗi khi giải mã thất bại
    rescue JWT::DecodeError => e
      return { success: false, message: "Lỗi khi giải mã refresh token: #{e.message}", status: unprocessable_entity}
    end
  end

end