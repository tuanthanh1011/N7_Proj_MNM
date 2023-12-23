require "./app/services/interview_service.rb"

class Api::V1::InterviewAdminController < ApplicationController

  # Thực hiện lấy ra tất cả bản ghi trong bảng interview
  def index_admin
    interviews = Interview.all
    # Phân trang, lọc, sắp xếp dữ liệu
    dataAfter = PaginationSortSearch.dataExploration(interviews, params, "InterviewCode")

    unless dataAfter[:success]
      render_response(dataAfter[:message], status: dataAfter[:status])
      return
    end

    # Chuyển đổi kết quả thành camel case
    result = CamelCaseConvert.convert_to_camel_case(dataAfter[:data].to_a)

    render_response("Hiển thị danh sách lịch phỏng vấn", data: {listData: result, totalCount: dataAfter[:totalCount]}, status: 200)
  end

  # Xóa mềm một bản ghi interview (by id)
  def destroy
    interviewCode = params[:id]
    result = InterviewService.deleteInterview(interviewCode)

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

    result = InterviewService.updateInterview(interviewCode, convert_params_to_uppercase(update_params))
  
    unless result[:success] 
     
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end

  # Hàm tạo mới phỏng vấn
  def create
   

    result = InterviewService.createInterview(convert_params_to_uppercase(create_params))

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
