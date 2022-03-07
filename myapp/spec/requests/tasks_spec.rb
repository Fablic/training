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
end
