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
            return { success: false, message: e.message, status: 400 }
        ensure
        end

    end

    def self.deleteAccount (accountCode)
        begin
            account = Auth.find_by(AccountCode: accountCode)
            if account
                account.destroy
                return { success: true}
            else 
                return { success: false, message: "Có lỗi khi xóa tài khoản", status: 400}
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        ensure
        end
    end

  end