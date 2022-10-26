# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/tasks', type: :request do
  let!(:user) { create(:user) }
  before do
    post '/login', params: { session: { email: user.email, password: user.password } }
  end

  let(:task_input_columns) { %w[name end_date priority status explanation] }

  describe 'GET /index' do
    context 'does NOT exist search_params' do
      let!(:tasks) { Kaminari.paginate_array(11.times.map { create(:task, user_id: user.id) }).page(page) }
      let!(:label_a) { create(:label, name: 'ラベルA') }
      let!(:label_b) { create(:label, name: 'ラベルB') }
      before do
        create(:task_label, task_id: tasks.first.id, label_id: label_a.id)
        create(:task_label, task_id: tasks.first.id, label_id: label_b.id)
      end

      context 'page:1' do
        let(:page) { 1 }

        it 'renders a successful response' do
          get tasks_url

          expect(response).to have_http_status(:ok)
          tasks.each { |task| expect(response.body).to include task.name.to_s }
          expect(response.body).to include label_a.name
          expect(response.body).to include label_b.name
        end
      end

      context 'page:2' do
        let(:page) { 2 }

        it 'renders a successful response' do
          get tasks_url + "/?page=#{page}"

          expect(response).to have_http_status(:ok)
          tasks.each { |task| expect(response.body).to include task.name.to_s }
        end
      end
    end

    context "When argument 'sort' exists in search_params" do
      let!(:tasks) { 11.times.map { create(:task, user_id: user.id) } }

      context 'created_at_asc' do
        let(:params) do
          { sort: 'created_at_asc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          Task.all.slice(0..9).each { |task| expect(response.body).to include task.name.to_s }
          expect(response.body).not_to include Task.all.last.name.to_s
        end
      end

      context 'created_at_desc' do
        let(:params) do
          { sort: 'created_at_desc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          Task.all.reverse.slice(0..9).each { |task| expect(response.body).to include task.name.to_s }
          expect(response.body).not_to include Task.all.reverse.last.name.to_s
        end
      end

      context 'end_date_asc' do
        let(:params) do
          { sort: 'end_date_asc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          Task.all.slice(0..9).each { |task| expect(response.body).to include task.name.to_s }
          expect(response.body).not_to include Task.all.last.name.to_s
        end
      end

      context 'end_date_desc' do
        let(:params) do
          { sort: 'end_date_desc' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          Task.all.reverse.slice(0..9).each { |task| expect(response.body).to include task.name.to_s }
          expect(response.body).not_to include Task.all.reverse.last.name.to_s
        end
      end
    end

    context 'exists keyword in search_params' do
      let!(:task_aqua) { create(:task, name: 'アクア', explanation: 'アイコンはくま', user_id: user.id) }
      let!(:task_kuma) { create(:task, name: 'くま', explanation: '毛が茶色い', user_id: user.id) }
      let!(:task_nyanko) { create(:task, name: 'にゃんこ', explanation: '毛が白い', user_id: user.id) }

      context 'keyword: くま' do
        let(:params) do
          { keyword: 'くま' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          expect(response.body).to include 'アクア'
          expect(response.body).to include 'くま'
          expect(response.body).not_to include 'にゃんこ'
        end
      end
    end

    context 'exists status in search_params' do
      let!(:task_aqua) { create(:task, name: 'アクア', status: 'untouched', user_id: user.id) }
      let!(:task_kuma) { create(:task, name: 'くま', status: 'touched', user_id: user.id) }
      let!(:task_nyanko) { create(:task, name: 'にゃんこ', status: 'completed', user_id: user.id) }
      let!(:task_piyo) { create(:task, name: 'ひよこ', status: 'untouched', user_id: user.id) }
      let!(:task_usa) { create(:task, name: 'うさぎ', status: 'untouched', user_id: user.id) }

      context 'status: untouched' do
        let(:params) do
          { status: 'untouched' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          expect(response.body).to include 'アクア'
          expect(response.body).not_to include 'くま'
          expect(response.body).not_to include 'にゃんこ'
          expect(response.body).to include 'ひよこ'
          expect(response.body).to include 'うさぎ'
        end
      end

      context 'status: completed' do
        let(:params) do
          { status: 'completed' }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          expect(response.body).not_to include 'アクア'
          expect(response.body).not_to include 'くま'
          expect(response.body).to include 'にゃんこ'
          expect(response.body).not_to include 'ひよこ'
          expect(response.body).not_to include 'うさぎ'
        end
      end
    end

    context 'exists label_ids in search_params' do
      let!(:task_aqua) { create(:task, name: 'アクア', user_id: user.id) }
      let!(:task_kuma) { create(:task, name: 'くま', user_id: user.id) }
      let!(:task_nyanko) { create(:task, name: 'にゃんこ', user_id: user.id) }
      let!(:task_piyo) { create(:task, name: 'ひよこ', user_id: user.id) }
      let!(:task_usa) { create(:task, name: 'うさぎ', user_id: user.id) }

      let!(:label_a) { create(:label, name: 'ラベルA') }
      let!(:label_b) { create(:label, name: 'ラベルB') }
      let!(:label_c) { create(:label, name: 'ラベルC') }

      before do
        create(:task_label, task_id: task_kuma.id, label_id: label_a.id)
        create(:task_label, task_id: task_kuma.id, label_id: label_b.id)
        create(:task_label, task_id: task_piyo.id, label_id: label_a.id)
        create(:task_label, task_id: task_usa.id, label_id: label_c.id)
      end

      context 'status: untouched' do
        let(:params) do
          { label_ids: [label_a.id, label_c.id] }
        end

        it 'renders a successful response' do
          get tasks_url, params: params

          expect(response).to have_http_status(:ok)
          expect(response.body).not_to include 'アクア'
          expect(response.body).to include 'くま'
          expect(response.body).not_to include 'にゃんこ'
          expect(response.body).to include 'ひよこ'
          expect(response.body).to include 'うさぎ'
        end
      end
    end
  end

  describe 'GET /show' do
    let(:task) { create(:task, user_id: user.id) }

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
    let(:task) { create(:task, user_id: user.id) }

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
        expect(response.body).to include 'タスク名は255文字以内で入力してください'
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid parameters' do
      let(:task) { create(:task, user_id: user.id) }

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
        expect(task.end_date.strftime('%Y/%m/%d %H:%M')).to eq new_attributes[:end_date].strftime('%Y/%m/%d %H:%M')
      end

      it 'redirects to the task' do
        put task_url(task), params: { task: new_attributes }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(task_url(task.reload))
      end
    end

    context 'with invalid parameters' do
      let(:task) { create(:task, user_id: user.id) }

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
        expect(response.body).to include 'タスク名は255文字以内で入力してください'
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:task) { create(:task, user_id: user.id) }

    it 'destroys the requested task' do
      expect { delete task_url(task) }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      delete task_url(task)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe '#bad_request' do
    let(:another_user) { create(:user) }
    let(:task) { create(:task, user_id: another_user.id) }

    shared_examples :returns_status400 do
      it 'returns status 400' do
        subject

        expect(response).to have_http_status :bad_request
        expect(response.body).to include '400なので念の為表示出来ないよ！'
        expect(response.body).to include '不正なことしてない〜？？'
      end
    end

    context '#show' do
      subject { get task_url(task) }
      it_behaves_like :returns_status400
    end

    context '#update' do
      subject { put task_url(task) }
      it_behaves_like :returns_status400
    end

    context '#destroy' do
      subject { delete task_url(task) }
      it_behaves_like :returns_status400
    end
  end

  describe '#not_found' do
    it 'returns status 404' do
      get '/aqua'

      expect(response).to have_http_status :not_found
      expect(response.body).to include '404なので僕のせいじゃないっす'
      expect(response.body).to include '多分アドレスとか違うっす'
    end

    it 'returns status 404' do
      get '/tasks/999999'

      expect(response).to have_http_status :not_found
      expect(response.body).to include '404なので僕のせいじゃないっす'
      expect(response.body).to include '多分アドレスとか違うっす'
    end
  end
end
