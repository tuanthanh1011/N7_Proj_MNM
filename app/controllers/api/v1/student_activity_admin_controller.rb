class Api::V1::StudentActivityAdminController < ApplicationController
    def create
        result = StudentActivity.createStudentActivity(convert_params_to_uppercase(create_params))

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
          :activityCode,
          :studentCode,
          :RatingCode
        )
    end
      
    private
    def convert_params_to_uppercase(params)
        params.transform_keys { |key| key.to_s.camelize.to_sym }
    end
end
