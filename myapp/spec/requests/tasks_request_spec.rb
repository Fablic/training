# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :request do
  it 'render the :index template' do
    get tasks_url
    expect(response.status).to eq(200)
  end

  it 'add new task url' do
    get new_task_url
    expect(response.status).to eq(200)
    expect(response.body).to include 'Add New Task'
  end

  describe 'Edit' do
    let(:task) { create :task }
    it 'Edit task page' do
      get edit_task_url task
      expect(response.status).to eq(200)
      expect(response.body).to include 'Editing Task'
    end
  end

  describe 'show tasks' do
    let(:task) { create :task }

    it 'show task' do
      get task_url task
      expect(response.status).to eq(200)
    end
  end

  describe 'create task' do
    context 'registration successful' do
      it 'added new task' do
        post tasks_url, params: { task: attributes_for(:task) }
        expect(response.status).to eq(302)
      end

      it 'added new task and task increased' do
        expect do
          post tasks_url, params: { task: attributes_for(:task) }
        end.to change(Task, :count).by(1)
      end
    end
  end

  describe 'Update' do
    let(:task) { create :task }

    it 'Updated Task' do
      expect do
        put task_url task, params: { task: attributes_for(:task, name: 'Updated Task Name') }
      end.to change { Task.find(task.id).name }.from('Task Name').to('Updated Task Name')
    end
  end

  describe 'DELETE' do
    let!(:task) { create :task }

    it 'Task Deleted' do
      expect do
        delete task_url task
      end.to change(Task, :count).by(-1)
    end
  end
end
