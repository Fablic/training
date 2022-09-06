# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/tasks', type: :request do
  describe 'GET /index' do
    let!(:tasks) { create_list(:task, 11) }

    it 'renders a successful response' do
      get tasks_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let!(:task) { create(:task) }

    it 'renders a successful response' do
      get task_url(task)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_task_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let!(:task) { create(:task) }

    it 'renders a successful response' do
      get edit_task_url(task)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:params) do
        { task: {
          name: 'task!',
          end_date: Time.current,
          priority: 'low',
          status: 'untouched',
          explanation: 'task_text!'
        } }
      end

      it 'creates a new Task' do
        expect do
          post tasks_url, params:
        end.to change(Task, :count).by(1)
      end

      it 'redirects to the created task' do
        post tasks_url, params: params
        expect(response).to redirect_to(task_url(Task.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { task: {
          name: 'task!' * 255,
          end_date: Time.current,
          priority: 'low',
          status: 'untouched',
          explanation: 'task_text!'
        } }
      end

      it 'does not create a new Task' do
        expect do
          post tasks_url, params: invalid_attributes
        end.to change(Task, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post tasks_url, params: invalid_attributes
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let!(:task) { create(:task) }

      let(:new_attributes) do
        {
          name: 'UpdatedTask!',
          end_date: Time.current,
          priority: 'high',
          status: 'untouched',
          explanation: 'UpdatedTaskText'
        }
      end

      it 'updates the requested task' do
        patch task_url(task), params: { task: new_attributes }
        expect(task.reload).to have_attributes new_attributes.reject { |_key| :end_date }
      end

      it 'redirects to the task' do
        patch task_url(task), params: { task: new_attributes }
        task.reload
        expect(response).to redirect_to(task_url(task))
      end
    end

    context 'with invalid parameters' do
      let!(:task) { create(:task) }

      let(:invalid_attributes) do
        { task: {
          name: 'task!' * 255,
          end_date: Time.current,
          priority: 'low',
          status: 'untouched',
          explanation: 'task_text!'
        } }
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch task_url(task), params: { task: invalid_attributes }
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:task) { create(:task) }

    it 'destroys the requested task' do
      expect do
        delete task_url(task)
      end.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      delete task_url(task)
      expect(response).to redirect_to(tasks_url)
    end
  end
end
