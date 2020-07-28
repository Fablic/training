# frozen_string_literal: true

require 'rails_helper'

describe TasksController, type: :controller do
  before do
    @task = FactoryBot.create(:task)
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
end
