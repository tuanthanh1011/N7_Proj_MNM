class Api::V1::InterviewController < ApplicationController
  def index
    interviews = Interview.all.to_a

    result = convert_interviews_to_camel_case(interviews)
    render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
  end

end