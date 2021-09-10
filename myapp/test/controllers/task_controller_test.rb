require 'test_helper'

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "should get delete" do
    get task_delete_url
    assert_response :success
  end

end
