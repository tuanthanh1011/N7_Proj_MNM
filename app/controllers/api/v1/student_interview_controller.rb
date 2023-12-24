class Api::V1::StudentInterviewController < ApplicationController
  def create
    student_code = params[:studentCode]
    interview_code = params[:interviewCode]

    # Gọi hàm lấy tất cả hoạt động (truyền params: lọc, sắp xếp, phân trang)
    result = StudentInterviewService.applyInterviewService(student_code, interview_code)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end
end
