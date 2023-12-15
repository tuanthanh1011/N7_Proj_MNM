class Api::V1::Admin::StudentInterviewAdminController < ApplicationController
    def update
      studentCode = params[:studentCode]
      resultInterview = params[:resultInterview]
  
      interview = Interview.find_by(StudentCode: studentCode, ResultInterview: nil)
  
      if interview
        if interview.update(ResultInterview: resultInterview)
          result = CamelCaseConvert.convert_to_camel_case(interview)
          render_response("Cập nhật thông tin phỏng vấn thành công", data: result, status: 200)
          interview.UpdatedAt = Time.now
        else
          render_response("Có lỗi khi cập nhật thông tin phỏng vấn", status: 422)
        end
      else
        render_response("Sinh viên không tồn tại", status: 404)
      end
    end
  end
  