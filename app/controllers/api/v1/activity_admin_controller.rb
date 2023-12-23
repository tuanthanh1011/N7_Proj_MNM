class Api::V1::ActivityAdminController < ApplicationController
    # Thực hiện lấy ra tất cả bản ghi trong bảng activity
  def index
    # Gọi hàm lấy tất cả hoạt động (truyền params: lọc, sắp xếp, phân trang)
    activities = ActivityAdminService.getAllActivities (params)
    
    # Xử lý lỗi
    unless activities[:success]
      render_response(activities[:message], status: activities[:status])
      return
    end

    render_response("Hiển thị danh sách hoạt động", data: activities[:data], status: activities[:status])
  end

  # Xem hoạt động (by id)
  def show
    activityCode = params[:id]

    activity = Activity.find_by(ActivityCode: params[:id])

    if activity
      render_response("Hiển thị hoạt động theo mã hoạt động", data: activity, status: 200)
    else 
      render_response("Không tìm thấy hoạt động", status: 404)
    end 
  end

  # Xóa mềm một bản ghi activity (by id)
  def destroy
    activity = Activity.find_by(ActivityCode: params[:id])
    if activity
        activity.destroy
      render_response("Xóa hoạt động thành công", status: 200)
    else 
      render_response("Hoạt động không tồn tại", status: 404)
    end
  end

  # Hàm cập nhật activity (activity by id)
  def update
    activityCode = params[:id]
  
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
  
  def convert_params_to_uppercase(params)
    params.transform_keys { |key| key.to_s.camelize.to_sym }
  end
end
