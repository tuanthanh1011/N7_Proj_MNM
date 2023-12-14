# services/student_service.rb
class AuthService
    def self.findAccountById (accountCode)
        account = Auth.find_by(AccountCode: accountCode, Role: true)
        if account
          return true
        else
          return false
        end
      end
  end