# frozen_string_literal: true
require 'debug'
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'basic user authentication' do
    assert User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('test1234')
    assert_not User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('notright')
    binding.break
    u = User.find_by(username: 'mvincent.yap@rakuten.com')&.authenticate('test1234')
    assert_equal 'mvincent', u.name
    assert_equal 1, u.id
  end
end
