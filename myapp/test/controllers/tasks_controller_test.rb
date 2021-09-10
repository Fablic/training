require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get tasks_edit_url
    assert_response :success
  end

  test "should get create" do
    get tasks_create_url
    assert_response :success
  end

  test "should get list" do
    get tasks_list_url
    assert_response :success
  end

  test "should get detail" do
    get tasks_detail_url
    assert_response :success
  end

end
