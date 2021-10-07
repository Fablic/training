require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "basic user authentication" do
    assert User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('test1234')   
    assert_not User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('notright')   
    U = User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('test1234')
    assert_equal "mvincent", U.name
    assert_equal 1, U.id
  end

end
