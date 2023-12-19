require "./app/services/student_service.rb"
require "./app/services/student_interview_service.rb"

class Api::V1::StudentInterviewController < ApplicationController
  def create
    student_code = params[:studentCode]
    interview_code = params[:interviewCode]

    # Xử lý kiểm tra đã là SVTN ?
    if StudentService.isVolunteer(student_code)
      render_response("Bạn đã là sinh viên tình nguyện", status: 400)
      return
    end

    # Xử lý kiểm tra sinh viên đã đăng ký phỏng vấn trước đó ?
    if StudentInterviewService.isApplyInterview(student_code)
      render_response("Bạn đã đăng ký trước đó rồi", status: 400)
      return
    end

    # Xử lý kiểm tra số lượng tham gia của phòng phán đoán
    result = InterviewService.updateQtt(interview_code)
    unless result[:success]
      render_response(result[:message], status: 400)
      return
    end

    # Tạo bản ghi student_interview
    student_interview = StudentInterview.new(
      StudentCode: student_code,
      InterviewCode: interview_code
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
        render_response("Đăng ký phỏng vấn thành công", data: data_student, status: 200)

      else
        render_response("Có lỗi khi đăng ký", status: 400)
      end
    rescue ActiveRecord::InvalidForeignKey => e
      render_response("Thông tin đăng ký không chính xác", status: 400)
    end
  end
end
