class VolunteerAccountService
    def self.createAccount (studentCode)
        begin
            account = Auth.new(
                Username: studentCode,
                Password: 123,
                Role: 0,
            )
        
            account.CreatedAt = Time.now
            
            if account.save
                return { success: true, accountCode: account.AccountCode}
            else
                raise StandardError.new("Lỗi khi tạo tài khoản")
            end

        rescue StandardError => e
            return { success: false, message: e.message }
        ensure
        end

    end

  end