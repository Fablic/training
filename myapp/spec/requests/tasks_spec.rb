# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /index' do
    context '一覧ページが存在する時' do
      it 'レスポンスが正しいこと' do
        get tasks_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'タスク名とステータスを同時検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { task_name: 'piyo', status: 1 } }

      context '検索したステータスと一致する時' do # rubocop:disable RSpec/NestedGroups
        before { create(:task, task_name: 'piyo', status: 1) }

        it 'レスポンスが正しいこと' do
          task_name_status_search
          expect(response).to have_http_status(:ok)
        end

        it 'ステータスとタスク名が一致しているタスクが含まれていること' do
          task_name_status_search
          expect(response.body).to include('piyo', '未着手')
        end
      end
    end

    context '一致するステータスを検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { status: 'yet_started' } }

      before { create(:task, task_name: 'hoge', status: 0) }

      it 'レスポンスが正しいこと' do
        task_name_status_search
        expect(response).to have_http_status(:ok)
      end

      it '一致するタスク名が表示されること' do
        task_name_status_search
        expect(response.body).to include 'hoge'
      end
    end

    context 'ステータスを検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { status: 'being_worked' } }

      context 'ステータスが一致していない時' do # rubocop:disable RSpec/NestedGroups
        before { create(:task, task_name: 'あいうえお', status: 2) }

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

      before { create(:task, task_name: '研修', status: 1) }

      it 'タスク名を全て表示すること' do
        task_name_status_search
        expect(response.body).to include '研修'
      end
    end

    context 'ステータスが未選択で、タスク名のみで検索した時' do
      subject(:task_name_status_search) { get tasks_path, params: { task_name: 'テスト', status: '' } }

      before { create(:task, task_name: 'テスト', status: 2) }

      it '該当するタスク名が表示されること' do
        task_name_status_search
        expect(response.body).to include 'テスト'
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
    context '詳細画面が存在する時' do
      subject(:new_task) { get tasks_path task.id }

      let(:task) { create(:task, task_name: 'Rails研修') }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:ok)
      end

      it 'タスクネームが表示されること' do
        new_task
        expect(response.body).to include 'Rails研修'
      end
    end
  end

  describe 'GET /edit' do
    context '編集画面が存在する時' do
      subject(:new_task) { get edit_task_path task.id }

      let(:task) { create(:task, task_name: 'hoge') }

      it 'レスポンスが正しいこと' do
        new_task
        expect(response).to have_http_status(:ok)
      end

      it 'taskの情報が取得できていること' do
        new_task
        expect(response.body).to include 'hoge'
      end
    end
  end

  describe 'PUT /update' do
    context 'タスク更新が成功した時' do
      subject(:new_task) { put task_url task, params: { task: attributes_for(:task, task_name: 'hoge') } }

      let(:task) { create(:task) }

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

      let(:task) { create(:task) }

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
        create_list(:task, 5)
        create(:task, task_name: 'aiueo')
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

      before do
        create_list(:task, 5)
      end

      it '2ページ目のボタンが存在しないこと' do
        task_page
        expect(response.body).not_to include '<a rel="next" href="/?page=2">2</a>'
      end
    end
  end
end
