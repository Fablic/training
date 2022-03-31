# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user) { create(:user) }

  before { post login_path, params: { session: { email: user.email, password: 'Passw0rd' } } }

  describe 'GET /index' do
    before do
      task = create(:task, task_name: 'piyo', status: 1, user: user)
      label = create(:label, label_name: 'rails')
      create(:task_label, task_id: task.id, label_id: label.id)
    end

    context '一覧ページが存在する時' do
      it 'レスポンスが正しいこと' do
        get tasks_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'タスク名とステータスとラベルを同時検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { task_name: 'piyo', status: 1, label_name: 'rails' } }

      it 'レスポンスが正しいこと' do
        task_name_status_search
        expect(response).to have_http_status(:ok)
      end

      it 'ステータスとタスク名とラベルが一致しているタスクが含まれていること' do
        task_name_status_search
        expect(response.body).to include('piyo', '着手', 'rails')
      end
    end

    context 'ステータスを検索した時' do
      context 'ステータスのみで検索した時' do # rubocop:disable RSpec/NestedGroups
        subject(:task_name_status_search) { get tasks_path, params: { status: 1 } }

        before { create(:task, task_name: 'piyo', status: 1) }

        it 'レスポンスが正しいこと' do
          task_name_status_search
          expect(response).to have_http_status(:ok)
        end

        it '該当するタスク名が表示されること' do
          task_name_status_search
          expect(response.body).to include 'piyo'
        end
      end

      context 'ステータスが一致していない時' do # rubocop:disable RSpec/NestedGroups
        subject(:task_name_status_search) { get tasks_path, params: { status: 2 } }

        before { create(:task, task_name: 'あいうえお', status: 1) }

        it 'レスポンスが正しいこと' do
          task_name_status_search
          expect(response).to have_http_status(:ok)
        end

        it '検索したタスク名が表示されていないこと' do
          task_name_status_search
          expect(response.body).not_to include 'あいうえお'
        end
      end
    end

    context 'ステータスが未選択で値が送られた時' do
      subject(:task_name_status_search) { get tasks_path, params: { status: '' } }

      it 'タスク名を全て表示すること' do
        task_name_status_search
        expect(response.body).to include 'piyo'
      end
    end

    context 'タスク名のみで検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { task_name: 'piyo', status: '' } }

      it '該当するタスク名が表示されること' do
        task_name_status_search
        expect(response.body).to include 'piyo'
      end
    end

    context 'ラベル検索した時' do
      context 'ラベルのみで検索した時' do # rubocop:disable RSpec/NestedGroups
        subject(:task_name_status_search) { get tasks_path, params: { task_name: '', status: '', label_name: 'rails' } }

        it '該当するラベルが表示されること' do
          task_name_status_search
          expect(response.body).to include 'rails'
        end
      end

      context 'ラベルが一致していない時' do # rubocop:disable RSpec/NestedGroups
        subject(:task_name_status_search) { get tasks_path, params: { task_name: '', status: '', label_name: 'rails' } }

        before { create(:task, task_name: 'かきくけこ', label: 'ruby') }

        it '検索したタスク名が表示されていないこと' do
          task_name_status_search
          expect(response.body).not_to include 'かきくけこ'
        end
      end
    end
  end

  describe 'GET /new' do
    context '作成画面が存在する時' do
      it 'レスポンスが正しいこと' do
        get new_task_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /create' do
    context 'タスクが作成された時' do
      subject(:new_task) { post tasks_path, params: { task: attributes_for(:task) } }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:found)
      end

      it 'タスクが登録されていること' do
        expect do
          new_task
        end.to change(Task, :count).by(1)
      end

      it 'リダイレクトされていること' do
        new_task
        expect(response).to redirect_to(task_path(Task.last))
      end

      it '作成成功フラッシュメッセージが存在すること' do
        new_task
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe 'GET /show' do
    context '詳細画面に遷移できる時' do
      subject(:new_task) { get task_path task }

      let(:task) { create(:task, task_name: 'piyo', status: 1, user: user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:ok)
      end

      it 'タスクネームが表示されること' do
        new_task
        expect(response.body).to include 'piyo'
      end
    end

    context '詳細画面に遷移できない時' do
      subject(:new_task) { get task_path task }

      let(:other_user) { create(:user) }
      let(:task) { create(:task, user: other_user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status (:not_found)
      end
    end
  end

  describe 'GET /edit' do
    context '編集画面に遷移できる時' do
      subject(:new_task) { get edit_task_path Task.last }

      before { create(:task, task_name: 'piyo', status: 1, user: user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:ok)
      end

      it 'taskの情報が取得できていること' do
        new_task
        expect(response.body).to include 'hoge'
      end
    end

    context '編集画面に遷移できない時' do
      subject(:new_task) { get edit_task_path task }

      let(:other_user) { create(:user) }
      let(:task) { create(:task, user: other_user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status (:not_found)
      end
    end
  end

  describe 'PUT /update' do
    context 'タスク更新が成功した時' do
      subject(:new_task) { put task_url task, params: { task: attributes_for(:task, task_name: 'hoge') } }

      let(:task) { create(:task, task_name: 'あいうえお', user: user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:found)
      end

      it 'タスク名が更新されていること' do
        new_task
        task.reload
        expect(task.task_name).to eq('hoge')
      end

      it '更新成功フラッシュメッセージが存在すること' do
        new_task
        expect(flash[:notice]).to be_present
      end

      it '更新されたタスクにリダイレクトされていること' do
        new_task
        expect(response).to redirect_to Task.last
      end
    end
  end

  describe 'DELETE /destory' do
    context 'タスク削除が成功した時' do
      subject(:new_task) { delete task_url task }

      let(:task) { create(:task, task_name: 'あいうえお', user: user) }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:found)
      end

      it '削除成功フラッシュメッセージが存在すること' do
        new_task
        expect(flash[:notice]).to be_present
      end

      it 'タスク一覧にリダイレクトすること' do
        new_task
        expect(response).to redirect_to(tasks_url)
      end

      it '該当IDで検索してもエラーになること' do
        new_task
        expect { Task.find(task.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'kaminari' do
    context 'タスクが6つ登録されている時' do
      before do
        create_list(:task, 5, task_name: 'piyo', status: 1, user: user)
        create(:task, task_name: 'aiueo', user: user)
      end

      it '2ページ目にタスクが1つ表示されていること' do
        get tasks_path, params: { page: 2 }
        expect(response.body).to include 'aiueo'
      end

      it '1ページ目に6つ目のタスクが表示されていないこと' do
        get tasks_path, params: { page: 1 }
        expect(response.body).not_to include 'aiueo'
      end

      it '1ページ目のボタンが存在すること' do
        get tasks_path, params: { page: 2 }
        expect(response.body).to include '<a rel="prev" href="/">1</a>'
      end
    end

    context 'タスクが5つ登録されている時' do
      subject(:task_page) { get tasks_path, params: { page: 1 } }

      before { create_list(:task, 5, task_name: 'piyo', status: 1, user: user) }

      it '2ページ目のボタンが存在しないこと' do
        task_page
        expect(response.body).not_to include '<a rel="next" href="/?page=2">2</a>'
      end
    end
  end
end
