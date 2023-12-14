require "test_helper"

class Api::V1::StudentInterviewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_student_interview_index_url
    assert_response :success
  end
end
