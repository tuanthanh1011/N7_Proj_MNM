class StudentService
  
  def self.findStudentByAccount(accountCode)
    student = Student.find_by(AccountCode: accountCode)
    return student.present?
  end

  def self.isVolunteer(studentCode)
    student = Student.find_by(StudentCode: studentCode, isVolunteerStudent: true)
    return student.present?
  end

  def self.updateVolunteer(studentCode)
    begin
      Student.where(StudentCode: studentCode).update_all(isVolunteerStudent: true, UpdatedAt: Time.now)
      return { success: true }
    rescue StandardError => e
      return { success: false, message: "Có lỗi khi cập nhật trạng thái sinh viên: #{e.message}" }
    end
  end

  def self.updateAccountCode(studentCode, accountCode)
    begin
      Student.where(StudentCode: studentCode).update_all(AccountCode: accountCode, UpdatedAt: Time.now)
      return { success: true }
    rescue ActiveRecord::StatementInvalid => e
      return { success: false, message: "Mã tài khoản cập nhật không chính xác: #{e.message}" }
    rescue StandardError => e
      return { success: false, message: "Có lỗi khi cập nhật tài khoản sinh viên: #{e.message}" }
    end
  end

  def self.update_del_volunteer(studentCode)
    begin
      student = Student.find_by(StudentCode: studentCode)
      
      if student
        accountCode = student.AccountCode
        if student.update(AccountCode: nil, isVolunteerStudent: false)
          student.update(UpdatedAt: Time.now)

          result = VolunteerAccountService.deleteAccount(accountCode)

          unless result[:success]
            return { success: false, message: result[:message], status: result[:status]}
          end

          return { success: true, message: "Xóa sinh viên tình nguyện thành công" }
        else
          return { success: false, message: "Có lỗi khi xóa sinh viên tình nguyện", status: 404 }
        end
      else
        return { success: false, message: "Sinh viên không tồn tại", status: 404 }
      end
    rescue StandardError => e
      return { success: false, message: "Có lỗi khi xóa sinh viên tình nguyện: #{e.message}", status: 400 }
    end
  end
end
