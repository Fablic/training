require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  # TODO: Test whether certain elements and texts exist on pages later. So far, this just tests the page existence.

  test '"GET /" returns success' do
    get '/'
    assert_response :success
  end

  test '"GET /tasks/new" returns success' do
    get '/tasks/new'
    assert_response :success
  end

  test '"GET /tasks/:id/edit" returns success' do
    get "/tasks/#{tasks(:base).id}/edit"
    assert_response :success
  end

  test '"POST /tasks" succeeds' do
    assert_difference -> { Task.count } do
      post '/tasks', params: { task: { name: 'New task!', description: 'Hey', priority: 'normal', status: 'waiting' } }
    end
    assert_response :redirect
  end

  test '"PATCH /tasks/:id" succeeds' do
    assert_changes -> { tasks(:base).reload.name } do
      patch "/tasks/#{tasks(:base).id}", params: { task: { name: 'Updated!' } }
    end
    assert_response :redirect
  end

  test '"DELETE /tasks/:id" succeeds' do
    assert_difference -> { Task.count }, -1 do
      delete "/tasks/#{tasks(:base).id}"
    end
    assert_response :redirect
  end
end
