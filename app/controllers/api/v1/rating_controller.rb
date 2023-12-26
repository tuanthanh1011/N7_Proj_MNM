class Api::V1::RatingController < ApplicationController
   # Hàm tạo mới đánh giá
  def create
    activityCode = params[:idActivity]
    studentCode = params[:idStudent]

    result = RatingService.createRating(convert_params_to_uppercase(create_params), activityCode, studentCode)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end

  def show
    activityCode = params[:id]
    result = RatingService.getRatingByActivity(activityCode, params)

    # Xử lý lỗi
    unless result[:success]
      render_response(result[:message], status: result[:status], errors: result[:errors])
      return
    end
  
    render_response(result[:message], status: 200)
  end
  
  def create_params
    params.permit(
      :ratingStar,
      :description,
    )
  end

  private
  def convert_params_to_uppercase(params)
    params.transform_keys { |key| key.to_s.camelize.to_sym }
  end
end
