require "test_helper"

class Api::V1::InterviewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_interview_index_url
    assert_response :success
  end
end
