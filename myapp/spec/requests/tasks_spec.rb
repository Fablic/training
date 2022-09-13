# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/tasks', type: :request do
  let(:task_input_columns) { %w[name end_date priority status explanation] }

  describe 'GET /index' do
    let!(:tasks) { create_list(:task, 11) }

    it 'renders a successful response' do
      get tasks_url

      expect(response).to have_http_status(:ok)
      tasks.each { |task| expect(response.body).to include task.name.to_s }
    end
  end

  describe 'GET /show' do
    let(:task) { create(:task) }

    it 'renders a successful response' do
      get task_url(task)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include task.name.to_s
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_task_url

      expect(response).to have_http_status(:ok)
      task_input_columns.each { |column| expect(response.body).to include "task[#{column}]" }
    end
  end

  describe 'GET /edit' do
    let(:task) { create(:task) }

    it 'renders a successful response' do
      get edit_task_url(task)

      expect(response).to have_http_status(:ok)
      task_input_columns.each { |column| expect(response.body).to include "task[#{column}]" }
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
        expect { post tasks_url, params: }.to change(Task, :count).by(1)
      end

      it 'redirects to the created task' do
        post tasks_url, params: params

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(task_url(Task.last))
      end
    end

    context 'without end_date, priority, status, explanation' do
      let(:params) do
        { task: { name: 'new_task!' } }
      end

      it 'creates a new Task' do
        expect { post tasks_url, params: }.to change(Task, :count).by(1)
        expect(Task.last).to have_attributes(
          {
            'name' => 'new_task!',
            'end_date' => nil,
            'priority' => 'normal',
            'status' => 'untouched',
            'explanation' => nil
          }
        )
      end

      it 'redirects to the created task' do
        post tasks_url, params: params

        expect(response).to have_http_status(:found)
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
        expect { post tasks_url, params: invalid_attributes }.to change(Task, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post tasks_url, params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include 'Name is too long (maximum is 255 characters)'
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid parameters' do
      let(:task) { create(:task) }

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
        put task_url(task), params: { task: new_attributes }

        expect(task.reload).to have_attributes new_attributes.except(:end_date)
        expect(I18n.l(task.end_date)).to eq I18n.l(new_attributes[:end_date])
      end

      it 'redirects to the task' do
        put task_url(task), params: { task: new_attributes }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(task_url(task.reload))
      end
    end

    context 'with invalid parameters' do
      let(:task) { create(:task) }

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
        put task_url(task), params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include 'Name is too long (maximum is 255 characters)'
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:task) { create(:task) }

    it 'destroys the requested task' do
      expect { delete task_url(task) }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      delete task_url(task)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(tasks_url)
    end
  end
end
