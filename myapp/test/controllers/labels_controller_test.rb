# frozen_string_literal: true

require 'test_helper'

class LabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label = create(:label)
    user = create(:admin)
    post '/login', params: { username: user.username, password: user.password }
  end

  test 'should get index' do
    get labels_url
    assert_response :success
  end

  test 'should get new' do
    get new_label_url
    assert_response :success
  end

  test 'should create label' do
    assert_difference('Label.count') do
      post labels_url, params: { label: attributes_for(:label) }
    end

    assert_redirected_to "#{label_url(Label.last)}?locale=ja"
  end

  test 'should show label' do
    get label_url(@label)
    assert_response :success
  end

  test 'should get edit' do
    get edit_label_url(@label)
    assert_response :success
  end

  test 'should update label' do
    patch label_url(@label), params: { label: attributes_for(:label) }
    assert_redirected_to "#{label_url(@label)}?locale=ja"
  end

  test 'should destroy label' do
    assert_difference('Label.count', -1) do
      delete label_url(@label)
    end

    assert_redirected_to "#{labels_url}?locale=ja"
  end
end
