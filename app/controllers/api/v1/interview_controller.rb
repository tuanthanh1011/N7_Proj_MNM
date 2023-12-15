class Api::V1::InterviewController < ApplicationController
  def index
    interviews = Interview.all.to_a

    result = convert_interviews_to_camel_case(interviews)
    render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
  end

  private

  def convert_interviews_to_camel_case(interviews)
    interviews.map do |interview|
      convert_keys_to_camel_case(interview.attributes)
    end
  end

  def convert_keys_to_camel_case(hash)
    hash.transform_keys { |key| key.to_s.camelize(:lower).to_sym }
  end
end