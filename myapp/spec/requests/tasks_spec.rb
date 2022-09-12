# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/tasks', type: :request do
  describe 'GET /index' do
    let!(:tasks) { create_list(:task, 11) }

    context 'does not exist search params' do
      it 'renders a successful response' do
        get tasks_url
        expect(response).to have_http_status(200)
      end
    end

    context 'exists sort in search_params' do
      context 'id_desc' do
        let(:params) do
          { sort: 'id_desc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params
          expect(response).to have_http_status(200)
        end
      end

      context 'end_date_asc' do
        let(:params) do
          { sort: 'end_date_asc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params
          expect(response).to have_http_status(200)
        end
      end

      context 'end_date_desc' do
        let(:params) do
          { sort: 'end_date_desc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:task) { create(:task) }

    it 'renders a successful response' do
      get task_url(task)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_task_url
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /edit' do
    let!(:task) { create(:task) }

    it 'renders a successful response' do
      get edit_task_url(task)
      expect(response).to have_http_status(200)
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

    context 'without end_date, priority, status, explanation' do
      let(:params) do
        { task: { name: 'new_task!' } }
      end

      it 'creates a new Task' do
        expect do
          post tasks_url, params:
        end.to change(Task, :count).by(1)
        expect(Task.last).to have_attributes({
                                               'name' => 'new_task!',
                                               'end_date' => nil,
                                               'priority' => 'normal',
                                               'status' => 'untouched',
                                               'explanation' => nil
                                             })
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
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /update' do
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
        put task_url(task), params: { task: new_attributes }

        expect(task.reload).to have_attributes new_attributes.except(:end_date)
        expect(I18n.l(task.end_date)).to eq I18n.l(new_attributes[:end_date])
      end

      it 'redirects to the task' do
        put task_url(task), params: { task: new_attributes }

        expect(response).to redirect_to(task_url(task.reload))
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
        put task_url(task), params: invalid_attributes

        expect(response).to have_http_status(422)
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
