# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'basic user authentication' do
    admin = create(:admin)
    assert User.find_by(username: admin.username)&.authenticate(admin.password)
    assert_not User.find_by(username: admin.username)&.authenticate('notright')

    u = User.find_by(username: admin.username)&.authenticate(admin.password)
    assert_equal admin.name, u.name
    assert_equal admin.id, u.id
    assert_equal true, u.admin

  end

  test 'basic user authentication of non admin' do
    non_admin = create(:non_admin)
    assert User.find_by(username: non_admin.username)&.authenticate(non_admin.password)
    assert_not User.find_by(username: non_admin.username)&.authenticate('notright')

    u = User.find_by(username: non_admin.username)&.authenticate(non_admin.password)
    assert_equal non_admin.name, u.name
    assert_equal non_admin.id, u.id
    assert_equal false, u.admin
  end
end
