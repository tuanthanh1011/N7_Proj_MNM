class StudentInterviewService

  # Hàm lấy ra tất cả sinh viên đang đăng ký tham gia phỏng vấn
  def self.getAllStudentInterviewService (params) 
    begin
      # Thực hiện join 2 bảng
      student_interview = StudentInterview.joins(:student)
      .select('student_interview.*, student.studentCode, student.studentName, student.className')
      .where(ResultInterview: nil).all

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


    def self.isApplyInterview (studentCode)
    studentInterview = StudentInterview.find_by(StudentCode: studentCode, ResultInterview: nil)
        if studentInterview
          return true
        else
          return false
        end
    end

end