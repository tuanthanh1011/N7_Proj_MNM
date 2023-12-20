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
    isValidInterviewDate = false
    isValidDeletedAt = false
    interviewCode = params[:id]
  
    if params.key?(:id)
      params.delete(:id)
    end

    # Kiểm tra định dạng ngày phỏng vấn
    if params[:interviewDate]
      interviewDate = params[:interviewDate]
      unless valid_date_format?(interviewDate)
        isValidInterviewDate = true
      end
    end

    # Kiểm tra định dạng ngày xóa phỏng vấn
    if params[:deletedAt]
      deletedAt = params[:deletedAt]
      unless valid_date_format?(deletedAt)
        isValidDeletedAt = true
      end
    end

    result = InterviewService.updateInterview(interviewCode, convert_params_to_uppercase(update_params))
  
    unless result[:success] 
      result[:errors] ||= [] 
      if isValidInterviewDate && params.values.all?(&:present?)
          result[:errors].push("Ngày phỏng vấn không đúng định dạng")
      end

      if isValidDeletedAt && params.values.all?(&:present?)
        result[:errors].push("Trường ngày xóa không đúng định dạng")
      end

      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end

  # Hàm tạo mới phỏng vấn
  def create
    isValidInterviewDate = false

    # Kiểm tra định dạng ngày phỏng vấn
    if params[:interviewDate]
      interviewDate = params[:interviewDate]
      unless valid_date_format?(interviewDate)
        isValidInterviewDate = true
      end
    end

    result = InterviewService.createInterview(convert_params_to_uppercase(create_params))

    unless result[:success]
      result[:errors] ||= [] 
      if isValidInterviewDate && params.values_at(:quantityMax, :interviewRoom).all?(&:present?) && params.values.all?(&:present?)
        result[:errors].push("Ngày phỏng vấn không đúng định dạng")
      end
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

  private

  def valid_date_format?(date_str)
    # Sử dụng regex để kiểm tra định dạng ngày (YYYY-MM-DD)
    regex = /\A\d{4}-\d{2}-\d{2}\z/
    return !!(date_str =~ regex)
  end
end
