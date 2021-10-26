# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = create(:task)
  end

  test 'should get index' do
    get tasks_url
    assert_response :success
  end

  test 'should get new' do
    get new_task_url
    assert_response :success
  end

  test 'should create task' do
    assert_difference('Task.count') do
      post tasks_url,
           params: { task: attributes_for(:task) }
    end

    assert_redirected_to "#{task_url(Task.last)}?locale=ja"
  end

  test 'should show task' do
    get task_url(@task)
    assert_response :success
  end

  test 'should get edit' do
    get edit_task_url(@task)
    assert_response :success
  end

  test 'should update task' do
    patch task_url(@task),
          params: { task: attributes_for(:task) }
    assert_redirected_to "#{task_url(@task)}?locale=ja"
  end

  test 'should destroy task' do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_redirected_to "#{tasks_url}?locale=ja"
  end
end
