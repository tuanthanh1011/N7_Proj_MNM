require "./app/services/interview_service.rb"

class Api::V1::Admin::InterviewAdminController < ApplicationController

  # Thực hiện lấy ra tất cả bản ghi trong bảng interview
  def index_admin
    interviews = Interview.all.to_a
    result = CamelCaseConvert.convert_to_camel_case(interviews)
    render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
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

    result = InterviewService.updateInterview(interviewCode, convert_params_to_uppercase(interview_params))
  
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end
  
    render_response(result[:message], status: 200)
  end

  # Hàm tạo mới phỏng vấn
  def create
    result = InterviewService.createInterview(convert_params_to_uppercase(interview_params))

    unless result[:success]
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end
  
  def interview_params
    params.permit(
      :interviewDate,
      :interviewRoom,
      :quantity,
      :quantityMax,
      :deletedAt
    )
  end
  
  private
  
  def convert_params_to_uppercase(params)
    params.transform_keys { |key| key.to_s.camelize.to_sym }
  end
end
