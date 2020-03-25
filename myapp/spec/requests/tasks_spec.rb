# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:headers) { { 'HTTP_USER_AGENT' => 'Chorme', 'REMOTE_ADDR' => '1.1.1.1' } }
  describe 'POST /tasks/:id' do
    let(:project) { create(:project, :with_group) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'Task creating is success' do
      it 'is created task' do
        post tasks_path, params: { task: {name: 'test1', description: 'test1', priority: 'high', group_id: project.groups.first.id}, project_id: project.id }, headers: headers
        expect(Task.count).to eq 1
        expect(flash[:alert]).to eq 'Success to create task'
        expect(response.status).to eq 302
      end
    end

    context 'Task creating is failed because, did not put task name' do
      it 'could not create task' do
        post tasks_path, params: { task: {name: nil, description: 'test1', priority: 'high', group_id: project.groups.first.id}, project_id: project.id }, headers: headers
        expect(Task.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create task'
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH /task/:id' do
    let(:project) { create(:project, :with_group) }
    let(:task) { create(:task, group: project.groups.first) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'Update success' do
      it 'is changing task name to test1' do
        patch task_path(locale: 'en', id: task.id), params: { task: { name: 'test1', description: 'test1', priority: 'high' } }, headers: headers
        task.reload
        expect(task.name).to eq 'test1'
        expect(flash[:alert]).to eq 'Success to updated task'
        expect(response.status).to eq 302
      end
    end

    context 'Task creating is failed because, did not put task name' do
      it 'could not change task name' do
        patch task_path(locale: 'en', id: task.id), params: { task: { name: nil, description: 'test1', priority: 'high' } }, headers: headers
        task.reload
        expect(task.name).to eq 'test task name'
        expect(flash[:alert]).to eq 'Failed to update task'
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE /task/:id' do
    let(:project) { create(:project, :with_group) }
    let(:task) { create(:task, group: project.groups.first) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'Project deleting is success' do
      it 'is deleting taks' do
        delete task_path(locale: 'en', id: task.id), headers: headers
        expect(project.groups.first.tasks.count).to eq 0
        expect(flash[:alert]).to eq 'Success to destroy task'
        expect(response.status).to eq 302
      end
    end

    context 'Task deleting is failed, because task id is not correct' do
      it 'could not delete task' do
        project
        task
        delete task_path(locale: 'en', id: 100), headers: headers
        expect(project.groups.first.tasks.count).to eq 1
        expect(response).to have_http_status(404)
      end
    end
  end
end
