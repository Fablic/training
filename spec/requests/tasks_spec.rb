# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:task) { create(:task, user: user) }
  let(:other_users_task) { create(:task, user: other_user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    post login_path, params: {
      session: { email: user.email, password: user.password }
    }
  end

  describe 'GET index' do
    it 'returns http success' do
      get tasks_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show' do
    context 'when show own task' do
      it 'returns http success' do
        get task_path(task)
        expect(response).to have_http_status(:success)
      end
    end

    context "when show other user's task" do
      it 'raises error' do
        expect do
          get task_path(other_users_task)
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET new' do
    it 'returns http success' do
      get new_task_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET edit' do
    context 'when edit own task' do
      it 'returns http success' do
        get edit_task_path(task)
        expect(response).to have_http_status(:success)
      end
    end

    context "when edit other user's task" do
      it 'raises error' do
        expect do
          get edit_task_path(other_users_task)
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST create' do
    it 'creates a task' do
      expect do
        post tasks_path, params: { task: attributes_for(:task, user: user) }
      end.to change(Task, :count).by(1)
    end

    it 'returns 302' do
      post tasks_path, params: { task: attributes_for(:task) }
      expect(response).to have_http_status(302)
    end
  end

  describe 'PUT update' do
    it 'updates a task' do
      put task_path(task), params: { task: attributes_for(:task, name: 'updated task') }
      expect(task.reload.name).to eq 'updated task'
    end

    it 'returns 302' do
      put task_path(task), params: { task: attributes_for(:task, name: 'updated task') }
      expect(response).to have_http_status(302)
    end
  end

  describe 'DELETE destroy' do
    let!(:task) { create(:task, user: user) }
    let!(:other_users_task) { create(:task, user: other_user) }

    context 'when delete own task' do
      it 'deletes a task' do
        expect do
          delete task_path(task)
        end.to change(Task, :count).by(-1)
      end

      it 'returns 302' do
        delete task_path(task)
        expect(response).to have_http_status(302)
      end
    end

    context "when delete other user's task" do
      it 'raises error' do
        expect do
          delete task_path(other_users_task)
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
