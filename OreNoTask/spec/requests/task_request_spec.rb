# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:rspec_session) { { user_id: user_taro.id } }
  let!(:user_taro) { create(:user, name: 'TaroRakuten', password: 'rakuten') }
  let(:params) { { task: { name: task_name, start_at: '2021-09-01 10:10:10', due_date_at: '2021-09-01 10:10:11', labels: '' } } }
  let(:task_name) { 'task' }

  describe '#index' do
    it '正常にアクセスできる' do
      get tasks_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#search' do
    context '正しいparam' do
      it '正常にアクセスできる' do
        get search_path, params: { keyword: 'a', status: 'b' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'paramなし' do
      it 'リダイレクトされる' do
        get search_path
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe '#new' do
    it '正常にアクセスできる' do
      get new_task_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    context '正しいPOST値' do
      it '新規レコードが作成された' do
        post tasks_path, params: params
        expect(response).to have_http_status(:found)
        expect(Task.active.count).to eq 1
      end
    end

    context 'POST値不足' do
      let(:task_name) { '' }

      it '入力エラー' do
        post tasks_path, params: params
        expect(response).to have_http_status(:ok)
        expect(Task.active.count).to eq 0
      end
    end

    context 'POST値不正' do
      let(:params_no_label) { { task: { name: task_name, start_at: '2021-09-01 10:10:10', due_date_at: '2021-09-01 10:10:11' } } }

      it 'システムエラー' do
        post tasks_path, params: params_no_label
        expect(response).to have_http_status(:internal_server_error)
        expect(Task.active.count).to eq 0
      end
    end
  end

  describe '#edit' do
    context 'Taskが存在する' do
      let(:task) { create(:task, name: '最初のタスク', user_id: user_taro.id) }

      it '正常にアクセスできる' do
        get edit_task_path(task)
        expect(response).to be_successful
      end
    end

    context 'Taskが存在しない' do
      it 'アクセスできない' do
        get edit_task_path(id: 1000)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '別ユーザーのタスクにアクセス' do
      let(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten') }
      let!(:hanako_task) { create(:task, name: '花子のタスク', user_id: user_hanako.id) }

      it 'アクセスできない' do
        get edit_task_path(id: hanako_task.id)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#update' do
    let!(:task) { create(:task, name: '最初のタスク', user_id: user_taro.id) }

    context '正しいPOST値' do
      it 'レコードが更新された' do
        put task_path(task), params: params
        expect(response).to have_http_status(:found)
        expect(Task.active.count).to eq 1
      end
    end

    context 'POST値不足' do
      let(:task_name) { '' }

      it '入力エラー' do
        put task_path(task), params: params
        expect(response).to have_http_status(:ok)
        expect(Task.active.count).to eq 1
      end
    end

    context 'POST値不正' do
      let(:params_no_label) { { task: { name: task_name, start_at: '2021-09-01 10:10:10', due_date_at: '2021-09-01 10:10:11' } } }

      it 'システムエラー' do
        put task_path(task), params: params_no_label
        expect(response).to have_http_status(:internal_server_error)
        expect(Task.active.count).to eq 1
      end
    end

    context '別のユーザーのタスク' do
      let(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten') }
      let!(:hanako_task) { create(:task, name: '花子のタスク', user_id: user_hanako.id) }

      it 'status 505' do
        put task_path(hanako_task), params: params
        expect(response).to have_http_status(:internal_server_error)
        expect(Task.active.count).to eq 2
      end
    end

    context 'task.save時にエラー' do
      let(:mock_tasks_controller) { TasksController.new }
      let(:label) { create(:label, name: 'ラベル') }

      before do
        create(:task_label, task_id: task.id, label_id: label.id)
        allow(mock_tasks_controller).to receive(:save_with_labels).and_raise StandardError
        allow(TasksController).to receive(:new).and_return mock_tasks_controller
      end

      it 'ロールバックが実行されること' do
        put task_path(task), params: params
        expect(response).to have_http_status(:ok)
        expect(Task.active.count).to eq 1
        expect(Label.all.count).to eq 1
        expect(TaskLabel.all.count).to eq 1
      end
    end
  end

  describe '#show' do
    context 'Taskが存在する' do
      let(:task) { create(:task, name: '最初のタスク', user_id: user_taro.id) }

      it '正常にアクセスできる' do
        get task_path(task)
        expect(response).to be_successful
      end
    end

    context 'Taskが存在しない' do
      it 'アクセスできない' do
        get task_path(id: 1000)
        expect(response.response_code).to eq(404)
      end
    end

    context '別ユーザーのタスクにアクセス' do
      let(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten') }
      let!(:hanako_task) { create(:task, name: '花子のタスク', user_id: user_hanako.id) }

      it 'アクセスできない' do
        get task_path(id: hanako_task.id)
        expect(response.response_code).to eq(404)
      end
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task, name: '最初のタスク', user_id: user_taro.id) }

    context '正しいPOST値' do
      it 'レコードが削除された' do
        delete task_path(task)
        expect(response).to have_http_status(:found)
        expect(Task.active.count).to eq 0
      end
    end

    context 'ID誤り' do
      it 'not found' do
        delete task_path(id: 1000)
        expect(response).to have_http_status(:not_found)
        expect(Task.active.count).to eq 1
      end
    end

    context '別のユーザーのタスク' do
      let(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten') }
      let!(:hanako_task) { create(:task, name: '花子のタスク', user_id: user_hanako.id) }

      it 'not found' do
        delete task_path(hanako_task)
        expect(response).to have_http_status(:not_found)
        expect(Task.active.count).to eq 2
      end
    end
  end
end
