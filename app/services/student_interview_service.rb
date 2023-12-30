class StudentInterviewService

  # Hàm lấy ra tất cả sinh viên đang đăng ký tham gia phỏng vấn
  def self.getAllStudentInterviewService (params) 
    begin
      # Thực hiện join 2 bảng
      student_interview = StudentInterview.joins(:student)
      .select('student_interview.*, student.studentCode, student.studentName, student.className').all

      # Phân trang, lọc, sắp xếp dữ liệu
      processedData = PaginationSortSearch.dataExploration(student_interview, params, "StudentName")

      unless processedData[:success]
        return {success: false, message: processedData[:message], status: processedData[:status]}
      end
      
      # Chuyển đổi kết quả thành camel case
      result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

      return { success: true, message: "Hiển thị danh sách lịch phỏng vấn", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}

    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    end
  end

  # Hàm cập nhật kết quả phỏng vấn (pass or fail)
  def self.updateResultService (studentCode, resultInterview)
    begin
      # Xử lý đầu vào chỉ bao gồm true hoặc false
      unless [true, false].include?(resultInterview)
        return { success: false, message: "Giá trị đầu vào không hợp lệ", status: 400}
      end

      # Tìm sinh viên với mã SV tương ứng
      updated_interview = StudentInterview.find_by(StudentCode: studentCode, ResultInterview: nil)

      if updated_interview
        StudentInterview.where(StudentCode: studentCode, ResultInterview: nil).update_all(ResultInterview: resultInterview, UpdatedAt: Time.now)

        # Kiểm tra nếu sinh viên pass pvan thì thực hiện mã
        if !!resultInterview == true
          # Cập nhật trạng thái sinh viên (table: student -> isVolunteer: true)
          resultUpdateVolunteer = StudentService.updateVolunteer(updated_interview.StudentCode)

          unless resultUpdateVolunteer[:success]
            return { success: false, message: resultUpdateVolunteer[:message], status: 400}
          end

          # Tự động tạo tài khoản cho sv pass pvan
          resultCreateAccount = VolunteerAccountService.createAccount(updated_interview.StudentCode)

          unless resultCreateAccount[:success]
            return { success: false, message: resultCreateAccount[:message], status: 400}
          end

          # Lấy ra accountCode của tài khoản vừa tạo
          accountCode = resultCreateAccount[:accountCode]

          # Cập nhật mã tài khoản vào bảng student
          resultUpdateAccountCode = StudentService.updateAccountCode(updated_interview.StudentCode, accountCode)

          unless resultUpdateAccountCode[:success]
            render_response(resultUpdateAccountCode[:message], status: 400)
            return { success: false, message: resultUpdateAccountCode[:message], status: 400}
          end
        end

        return { success: true, message: "Cập nhật thông tin phỏng vấn thành công", status: 200}
      else
        return { success: false, message: "Sinh viên hiện không nằm trong danh sách phỏng vấn", status: 404}
      end
    rescue StandardError => e
      return { success: false, message: e.message, status: 400}  
    end
  end

  # Hàm lấy ra các sinh viên trong 1 phỏng vấn
  def self.getStudentByInterview (interviewCode, params)
    begin
      student_interview = StudentInterview.joins(:student)
      .select('student_interview.*, student.studentCode, student.studentName, student.className, student.phoneNumber, student.email')
      .where(InterviewCode: interviewCode).all

      if student_interview
        # Phân trang, lọc, sắp xếp dữ liệu
        processedData = PaginationSortSearch.dataExploration(student_interview, params, "StudentName")
  
        unless processedData[:success]
          return {success: false, message: processedData[:message], status: processedData[:status]}
        end
        # Chuyển đổi kết quả thành camel case
        result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

        return { success: true, message: "Hiển thị danh sách sinh viên theo phỏng vấn", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
      else 
        return {success: false, message: "Không tìm thấy phỏng vấn", status: 400}
      end 
    rescue StandardError => e
        return { success: false, message: e.message, status: 400 }
    end
end

  # Hàm kiểm tra sinh viên đã đăng ký phỏng vấn trước đó chưa
  def self.isApplyInterview (studentCode, interviewCode)
    studentInterview = StudentInterview.find_by(StudentCode: studentCode, InterviewCode: interviewCode)
    if studentInterview
      return true
    else
      return false
    end
  end

  # Hàm đăng ký phỏng vấn
  def self.applyInterviewService (studentCode, interviewCode)
    begin

      # Xử lý kiểm tra sinh viên đã đăng ký phỏng vấn trước đó ?
      if StudentInterviewService.isApplyInterview(studentCode, interviewCode)
        return { success: false, message: "Bạn đã đăng ký phỏng vấn này trước đó rồi", status: 400}
      end

      # Xử lý kiểm tra số lượng tham gia của phòng phán đoán
      result = InterviewService.updateQtt(interviewCode)
      unless result[:success]
        return { success: false, message: result[:message], status: 400}
      end

      # Tạo bản ghi student_interview
      student_interview = StudentInterview.new(
        StudentCode: studentCode,
        InterviewCode: interviewCode
      )
      student_interview.CreatedAt = Time.now

      begin
        # Lưu bản ghi 
        if student_interview.save

          # Xử lý data trả về response
          data_student = {
            studentCode: student_interview.StudentCode,
            interviewCode: student_interview.InterviewCode,
            createdAt: student_interview.CreatedAt,
          }
          return { success: true, message: "Đăng ký phỏng vấn thành công", data: data_student, status: 200}
        else
          return { success: false, message: "Có lỗi khi đăng ký", errors: student_interview.errors.full_messages, status: 400}
        end
      rescue ActiveRecord::InvalidForeignKey => e
        return { success: false, message: "Thông tin đăng ký không chính xác", status: 400}
      end

    rescue StandardError => e
      return { success: false, message: e.message, status: 400}
    end

  end

end