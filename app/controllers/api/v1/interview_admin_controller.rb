
class Api::V1::InterviewAdminController < ApplicationController

  # Thực hiện lấy ra tất cả bản ghi trong bảng interview
  def index_admin

    # Gọi hàm lấy tất cả hoạt động (truyền params: lọc, sắp xếp, phân trang)
    result = InterviewAdminService.getAllInterviewService (params)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

  # Xóa mềm một bản ghi interview (by id)
  def destroy
    interviewCode = params[:id]
    result = InterviewAdminService.deleteInterviewService(interviewCode)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], status: 200)
  end

  # Hàm cập nhật phỏng vấn (interview by id)
  def update
    interviewCode = params[:id]
  
    if params.key?(:id)
      params.delete(:id)
    end

    result = InterviewAdminService.updateInterviewService(interviewCode, convert_params_to_uppercase(update_params))
  
    # Xử lý lỗi
    unless result[:success] 
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end

  # Hàm tạo mới phỏng vấn
  def create
    result = InterviewAdminService.createInterviewService(convert_params_to_uppercase(create_params))

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end
  
  def update_params
    params.permit(
      :interviewDate,
      :interviewRoom,
      :quantity,
      :quantityMax,
      :deletedAt
    )
  end

  def create_params
    params.permit(
      :interviewDate,
      :interviewRoom,
      :quantityMax
    )
  end
  
  private
  def convert_params_to_uppercase(params)
    params.transform_keys { |key| key.to_s.camelize.to_sym }
  end

end
