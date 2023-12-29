class Api::V1::ActivityAdminController < ApplicationController
    # Thực hiện lấy ra tất cả bản ghi trong bảng activity
  def index
    # Gọi hàm lấy tất cả hoạt động (truyền params: lọc, sắp xếp, phân trang)
    result = ActivityAdminService.getAllActivities (params)
    
    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

  # Xem hoạt động (by id)
  def show
    activityCode = params[:id]

    result = ActivityAdminService.getActivityById(activityCode)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], data: result[:data], status: result[:status])
  end

  # Xóa mềm một bản ghi activity (by id)
  def destroy
    # Lấy ra id truyền trong param
    activityCode = params[:activityCode]

    result = ActivityAdminService.deleteActivity(activityCode)

    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], status: result[:status])
  end

  # Hàm cập nhật activity (activity by id)
  def update
    # Lấy ra id truyền trong param
    activityCode = params[:id]
  
    # Loại bỏ id trong object parameters
    if params.key?(:id)
      params.delete(:id)
    end

    result = ActivityService.updateActivity(activityCode, convert_params_to_uppercase(activity_params))
  
    unless result[:success] 
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end


  # Hàm tạo mới hoạt động
  def create

    result = ActivityService.createActivity(convert_params_to_uppercase(activity_params))

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
    worksheet.row(0).concat %w{Mã_hoạt_động Tên_hoạt_động Ngày_bắt_đầu Người_quản_lý Chi_phí_hỗ_trợ Mô_tả Ngày_tạo Đánh_giá_trung_bình Số_người_tham_gia}
  
    # Truy vấn cơ sở dữ liệu để lấy dữ liệu
    data_from_db = Activity.left_joins(student_activity: :rating)
    .select('activity.*, COALESCE(CONVERT(ROUND(AVG(rating.RatingStar), 2), DECIMAL(10, 2)), 0) AS averageRating', 'COALESCE(COUNT(student_activity.ActivityCode), 0) AS numOfParticipant')
    .group('activity.ActivityCode')
    .map do |activity|
      activity.averageRating = activity.averageRating.to_f
      activity
    end
  
    # Thêm dữ liệu từ cơ sở dữ liệu vào worksheet
    data_from_db.each_with_index do |data, index|
      worksheet.row(index + 1).concat [data.ActivityCode, data.ActivityName, data.BeginingDate, data.Manager, data.SupportMoney, data.Description, data.CreatedAt, data.averageRating, data.numOfParticipant]
    end
  
    # Tạo một string để lưu trữ nội dung của workbook
    excel_data = StringIO.new
    workbook.write(excel_data)
    excel_data.rewind
  
    # Trả về tệp Excel dưới dạng response để tải xuống
    send_data(
      excel_data.read,
      type: 'application/vnd.ms-excel',
      filename: 'Danh sách hoạt động.xls'
    )
  end

  # Khai báo các trường được chấp nhận trong body request
  def activity_params
    params.permit(
      :activityName,
      :beginingDate,
      :manager,
      :supportMoney,
      :description
    )
  end
  
  private
  
  # Hàm chuyển đổi từ camelcase sang uppercase
  def convert_params_to_uppercase(params)
    params.transform_keys { |key| key.to_s.camelize.to_sym }
  end
end
