class Api::V1::Admin::InterviewAdminController < ApplicationController
    def index_admin
        interviews = Interview.all.to_a
    
        result = CamelCaseConvert.convert_to_camel_case(interviews)
        render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
      end
end
