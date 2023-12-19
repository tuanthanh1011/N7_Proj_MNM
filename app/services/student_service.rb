# services/student_service.rb
class StudentService
  # Hàm tìm kiếm sinh viên theo accountCode
  def self.findStudentByAccount(accountCode)
    student = Student.find_by(AccountCode: accountCode)
    return student.present?
  end

  # Hàm kiểm tra sv đã là sv tình nguyện chưa
  def self.isVolunteer(studentCode)
    student = Student.find_by(StudentCode: studentCode, isVolunteerStudent: true)
    return student.present?
  end

  # Hàm cập nhật trạng thái sinh viên
  def self.updateVolunteer(studentCode)
    begin
      Student.where(StudentCode: studentCode).update_all(isVolunteerStudent: true, UpdatedAt: Time.now)
      return { success: true }
    rescue StandardError => e
      return { success: false, message: "Có lỗi khi cập nhật trạng thái sinh viên: #{e.message}" }
    end
  end

  # Hàm cập nhật accountCode vào bảng student
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
end
