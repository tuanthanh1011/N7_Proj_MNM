
class Api::V1::StudentInterviewController < ApplicationController
  def create
    studentCode = params[:StudentCode]
    interviewCode = params[:InterviewCode]

    if isExist(studentCode, interviewCode)
      render_response("Bạn đã đăng ký trước đó rồi")
      return 
    end

    student_interview = StudentInterview.new(
      StudentCode: studentCode,
      InterviewCode: interviewCode
    )

    student_interview.CreatedAt = Time.now
    
    begin
      if student_interview.save
        render_response("Đăng ký phỏng vấn thành công", data: student_interview)
      else
        render_response("Có lỗi khi đăng ký", nil, student_interview.errors.full_messages)
      end
    rescue ActiveRecord::InvalidForeignKey => e
      render_response("Thông tin đăng ký không đúng")
    end
  end

  def isExist (studentCode, interviewCode)
    student_interview = StudentInterview.find_by(StudentCode: studentCode)
    if student_interview
      true
    end
  end

end
