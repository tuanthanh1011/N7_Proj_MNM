class Api::V1::InterviewController < ApplicationController
  def index
    # Gọi hàm lấy tất cả phỏng vấn (truyền params: lọc, sắp xếp, phân trang)
    result = InterviewService.getAllInterviewService (params)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

end