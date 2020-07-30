# frozen_string_literal: true

require 'rails_helper'

describe TasksController, type: :controller do
  render_views

  before do
    @task = FactoryBot.create(:task)

    @task1 = create(:task, name: 'task1', created_at: Time.zone.tomorrow)
    @task2 = create(:task, name: 'task2', created_at: Time.zone.yesterday)
  end

  it 'render the :index template' do
    get :index
    expect(response).to render_template :index
  end

  it 'Find task by id' do
    get :show, params: { id: @task[:id] }
    expect(response.status).to eq 302
  end

  it 'Display new task screen' do
    get :new
    expect(response.status).to eq 200
  end

  it 'Create new task' do
    expect(Task.count).to eq 1
    post :create, params: { task: { name: 'テストタスク', due_date: '2020/07/01' } }
    expect(response.status).to eq 302
    expect(Task.count).to eq 2
  end

  it 'Create new task fail' do
    expect(Task.count).to eq 1
    post :create, params: { task: { due_date: '2020/07/01' } }
    expect(response).to render_template :new
    expect(Task.count).to eq 1
  end

  it 'Display update screen' do
    get :edit, params: { id: @task[:id] }
    expect(response.status).to eq 200
  end

  it 'Update task' do
    new_task_name = @task[:name] + ' Edit'
    put :update, params: { id: @task[:id], task: { name: new_task_name } }
    expect(response.status).to eq 302
    expect(Task.find(@task.id).name).to eq new_task_name
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
    expect(Task.count).to eq 1
    delete :destroy, params: { id: @task[:id] }
    expect(response.status).to eq 302
    expect(Task.count).to eq 0
  end

  it 'Sort by created_at desc' do
    get :index, params: { search_form: { sort_direction: 'desc' } }
    expect(response.status).to eq 200

    res_str = response.body

    task1_index = res_str.index('task1')
    task2_index = res_str.index('task2')

    expect(task1_index).to be < task2_index
  end

  it 'Sort by created_at asc' do
    get :index, params: { search_form: { sort_direction: 'asc' } }
    expect(response.status).to eq 200

    res_str = response.body

    task1_index = res_str.index('task1')
    task2_index = res_str.index('task2')

    expect(task1_index).to be > task2_index
  end
end
