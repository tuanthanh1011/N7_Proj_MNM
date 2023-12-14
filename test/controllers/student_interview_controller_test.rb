require "test_helper"

class StudentInterviewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get student_interview_index_url
    assert_response :success
  end
end
