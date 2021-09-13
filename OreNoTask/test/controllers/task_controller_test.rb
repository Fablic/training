require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get task_index_url
    assert_response :success
  end

  test "should get edit" do
    get task_edit_url
    assert_response :success
  end

  test "should get detail" do
    get task_detail_url
    assert_response :success
  end

  test "should get delete" do
    get task_delete_url
    assert_response :success
  end
end
