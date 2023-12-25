class Api::V1::StudentActivityAdminController < ApplicationController
    def create
        activityCode = params[:id]
        result = StudentActivityAdminService.createStudentActivityService(convert_params_to_uppercase(create_params), activityCode)

        unless result[:success]
          
          if result[:errors].nil?
            result[:errors] = []
          end

          render_response(result[:message], status: result[:status], errors: result[:errors])
          return
        end
      
        render_response(result[:message], status: 200)
    end

    def show 
      activityCode = params[:id]
      result = StudentActivityAdminService.getStudentByActivity(params, activityCode)

        unless result[:success]
          render_response(result[:message], status: result[:status])
          return
        end
      
        render_response(result[:message], data: result[:data], status: 200)
    end

    def create_params
        params.permit(
          studentCode: [],
        )
    end
      
    private
    def convert_params_to_uppercase(params)
        params.transform_keys { |key| key.to_s.camelize.to_sym }
    end
end
