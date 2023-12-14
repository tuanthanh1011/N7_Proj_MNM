class Api::V1::InterviewController < ApplicationController
  def index
    interviews = Interview.all
    render_response("Hiển thị danh sách lịch phỏng vấn", data: interviews)
  end
end
