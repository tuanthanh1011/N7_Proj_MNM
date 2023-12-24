require "./app/services/student_service.rb"
require "./app/services/volunteer_account_service.rb"

class Api::V1::StudentInterviewAdminController < ApplicationController
  def index
    # Gọi hàm lấy tất cả hoạt động (truyền params: lọc, sắp xếp, phân trang)
    result = StudentInterviewService.getAllStudentInterviewService (params)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

  def update
    # Lấy dữ liệu gửi trong body
    studentCode = params[:id]
    resultInterview = params[:resultInterview]

    result = StudentInterviewService.updateResultService(studentCode, resultInterview)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

  def show
    interviewCode = params[:id]

    result = StudentInterviewService.getStudentByInterview(interviewCode, params)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

end
