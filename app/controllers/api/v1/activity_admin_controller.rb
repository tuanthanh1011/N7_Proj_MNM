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
    activityCode = params[:id]

    result = ActivityAdminService.deleteActivity(activityCode)

    unless result[:success]
      render_response(result[:message], status: result[:status])
      return
    end

    render_response(result[:message], status: result[:status])
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
