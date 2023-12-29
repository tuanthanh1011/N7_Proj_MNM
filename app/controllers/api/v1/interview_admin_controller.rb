
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
    interviewCode = params[:interviewCode]
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

  require 'spreadsheet'
  def export_file
    # Tạo một workbook mới
    workbook = Spreadsheet::Workbook.new
  
    # Tạo một worksheet trong workbook
    worksheet = workbook.create_worksheet(name: 'Sheet1')
  
    # Thêm tiêu đề cho worksheet
    worksheet.row(0).concat %w{Mã_phỏng_vấn Ngày_phỏng_vấn Phỏng_phòng_vấn Số_lượng_tham_gia Số_lượng_tối_đa Ngày_tạo Ngày_xóa}
  
    # Truy vấn cơ sở dữ liệu để lấy dữ liệu
    data_from_db = Interview.all
  
    # Thêm dữ liệu từ cơ sở dữ liệu vào worksheet
    data_from_db.each_with_index do |data, index|
      worksheet.row(index + 1).concat [data.InterviewCode, data.InterviewDate, data.InterviewRoom, data.Quantity, data.QuantityMax, data.CreatedAt, data.DeletedAt]
    end
  
    # Tạo một string để lưu trữ nội dung của workbook
    excel_data = StringIO.new
    workbook.write(excel_data)
    excel_data.rewind
  
    # Trả về tệp Excel dưới dạng response để tải xuống
    send_data(
      excel_data.read,
      type: 'application/vnd.ms-excel',
      filename: 'Danh sách phỏng vấn.xls'
    )
  end
  
  def update_params
    params.permit(
      :interviewDate,
      :interviewRoom,
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
