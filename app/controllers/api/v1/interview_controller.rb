class Api::V1::InterviewController < ApplicationController
  def index
    interviews = Interview.where(deletedAt: nil).to_a

    result = CamelCaseConvert.convert_to_camel_case(interviews)
    render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
  end

end