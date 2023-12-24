require "test_helper"

class Api::V1ControllerTest < ActionDispatch::IntegrationTest
  test "should get student_activity_controller" do
    get api_v1_student_activity_controller_url
    assert_response :success
  end
end
