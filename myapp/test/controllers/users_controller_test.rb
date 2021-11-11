# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:admin)
    post '/login', params: { username: @user.username, password: @user.password }
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: attributes_for(:generic_user) }
    end

    assert_redirected_to "#{user_url(User.last)}?locale=ja"
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: attributes_for(:generic_user) }
    assert_redirected_to "#{user_url(@user)}?locale=ja"
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to "#{users_url}?locale=ja"
  end
end
