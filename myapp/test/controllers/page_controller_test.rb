require 'test_helper'

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get page_list_url
    assert_response :success
  end

end
