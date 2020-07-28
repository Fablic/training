# frozen_string_literal: true

require 'rails_helper'

describe TasksController, type: :controller do
  render_views

  before do
    @app_user = FactoryBot.create(:app_user)
    @task = FactoryBot.create(:task, app_user: @app_user)

    @task1 = create(:task, name: 'task1', created_at: Time.zone.tomorrow, status: 1, app_user: @app_user)
    @task2 = create(:task, name: 'task2', created_at: Time.zone.yesterday, app_user: @app_user)

    session[:current_user_id] = @app_user.id
  end

  it 'render the :index template' do
    get :index
    expect(response).to render_template :index
  end

  it 'Find task by id' do
    get :show, params: { id: @task[:id] }
  end

  it 'Display new task screen' do
    get :new
    expect(response.status).to eq 200
  end

  it 'Create new task' do
    post :create, params: { task: { name: 'テストタスク', due_date: '2020/07/01' } }
    expect(response.status).to eq 302
  end

  it 'Create new task fail' do
    post :create, params: { task: { due_date: '2020/07/01' } }
    expect(response).to render_template :new
  end

  it 'Display update screen' do
    get :edit, params: { id: @task[:id] }
    expect(response.status).to eq 200
  end

  it 'Update task' do
    put :update, params: { id: @task[:id], task: { name: @task[:name] + ' Edit' } }
    expect(response.status).to eq 302
  end

  it 'Update task fail' do
    put :update, params: { id: @task[:id], task: { name: '' } }
    expect(response).to render_template :edit
  end

  it 'Update task not found' do
    put :update, params: { id: 1000, task: { name: @task[:name] + ' Edit' } }
    expect(response.status).to eq 404
  end

  it 'Delete task' do
    delete :destroy, params: { id: @task[:id] }
    expect(response.status).to eq 302
  end

  it 'Sort by updated_at desc' do
    get :index, params: { search_form: { sort_direction: 'desc' } }
    expect(response.status).to eq 200

    res_str = response.body

    task1_index = res_str.index('task1')
    task2_index = res_str.index('task2')

    expect(task1_index).to be > task2_index
  end

  it 'Sort by updated_at asc' do
    get :index, params: { search_form: { sort_direction: 'asc' } }
    expect(response.status).to eq 200

    res_str = response.body

    task1_index = res_str.index('task1')
    task2_index = res_str.index('task2')

    expect(task1_index).to be < task2_index
  end

  it 'Search filter by status' do
    get :index, params: { search_form: { sort_direction: 'asc', status: 1 } }
    expect(response.status).to eq 200
    res_str = response.body
    expect(res_str).to include('task1')
    expect(res_str).not_to include('task2')
    expect(res_str).not_to include('タスク名')
  end

  it 'Search filter by empty status' do
    get :index, params: { search_form: { sort_direction: 'asc', status: '' } }
    expect(response.status).to eq 200
    res_str = response.body
    expect(res_str).to include('task1')
    expect(res_str).to include('task2')
    expect(res_str).to include('タスク名')
  end
end
