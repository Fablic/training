require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe 'GET index' do
    before do
      create(:task)
      create(:task, name: 'タスク名2', description: '詳しい説明2', status: 'done')
    end

    it 'リクエストが成功すること' do
      get tasks_url
      expect(response.status).to eq(200)
    end

    it 'Task List Pageが表示されること' do
      get tasks_url
      expect(response.body).to include 'Task List Page'
    end

    it 'タスク名が2件表示されていること' do
      get tasks_url
      expect(response.body).to include 'タスク名'
      expect(response.body).to include 'タスク名2'
    end

    it 'タスク詳細が2件表示されていること' do
      get tasks_url
      expect(response.body).to include '詳しい説明'
      expect(response.body).to include '詳しい説明2'
    end

    it 'ステータスが2件表示されていること' do
      get tasks_url
      expect(response.body).to include '未着手'
      expect(response.body).to include '完了'
    end
  end

  describe 'GET new' do
    it 'リクエストが成功すること' do
      get new_task_url
      expect(response.status).to eq(200)
    end

    it 'Task Registration Pageが表示されること' do
      get new_task_url
      expect(response.body).to include 'Task Registration Page'
    end
  end

  describe 'GET edit' do
    let(:task) { FactoryBot.create :task }

    it 'リクエストが成功すること' do
      get edit_task_url task
      expect(response.status).to eq(200)
    end

    it 'Task Edit Pageが表示されること' do
      get edit_task_url task
      expect(response.body).to include 'Task Edit Page'
    end

    it 'タスク名が表示されていること' do
      get edit_task_url task
      expect(response.body).to include 'タスク名'
    end

    it 'タスク詳細が表示されていること' do
      get edit_task_url task
      expect(response.body).to include '詳しい説明'
    end

    it 'ステータスが表示されていること' do
      get edit_task_url task
      expect(response.body).to include '未着手'
    end
  end

  describe 'GET show' do
    let(:task) { FactoryBot.create :task }

    it 'リクエストが成功すること' do
      get task_url task
      expect(response.status).to eq(200)
    end

    it 'Task Detail Pageが表示されること' do
      get task_url task
      expect(response.body).to include 'Task Detail Page'
    end

    it 'タスク名が表示されていること' do
      get task_url task
      expect(response.body).to include 'タスク名'
    end

    it 'タスク詳細が表示されていること' do
      get task_url task
      expect(response.body).to include '詳しい説明'
    end

    it 'ステータスが表示されていること' do
      get task_url task
      expect(response.body).to include '未着手'
    end
  end

  describe 'POST create' do
    context '登録が成功する場合' do
      it 'リクエストが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response.status).to eq(302)
      end

      it 'タスクが1件登録されること' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        end.to change(Task, :count).by(1)
      end

      it 'タスク一覧画面にリダイレクトされること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to redirect_to tasks_path
      end
    end

    context '登録が成功しない場合' do
      it 'リクエストが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        expect(response.status).to eq(200)
      end

      it 'タスクが登録されないこと' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        end.to_not change(Task, :count)
      end

      it 'エラーが表示されること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        expect(response.body).to include 'タスク名を入力してください'
      end
    end
  end

  describe 'PUT update' do
    let(:task) { FactoryBot.create :task }

    context '更新が成功する場合' do
      it 'リクエストが成功すること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:task, name: '更新後タスク名', description: 'より詳しい説明') }
        expect(response.status).to eq(302)
      end

      it 'タスク名が更新されること' do
        expect do
          put task_url task, params: { task: FactoryBot.attributes_for(:task, name: '更新後タスク名') }
        end.to change { Task.find(task.id).name }.from('タスク名').to('更新後タスク名')
      end

      it 'タスク詳細が更新されること' do
        expect do
          put task_url task, params: { task: FactoryBot.attributes_for(:task, description: 'より詳しい説明') }
        end.to change { Task.find(task.id).description }.from('詳しい説明').to('より詳しい説明')
      end

      it 'タスク一覧画面にリダイレクトされること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:task, name: '更新後タスク名', description: 'より詳しい説明') }
        expect(response).to redirect_to tasks_path
      end
    end

    context '登録が成功しない場合' do
      it 'リクエストが成功すること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        expect(response.status).to eq(200)
      end

      it 'タスク名が変更されないこと' do
        expect do
          put task_url task, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        end.to_not change(Task.find(task.id), :name)
      end

      it 'エラーが表示されること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:task, :invalid) }
        expect(response.body).to include 'タスク名を入力してください'
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:task) { FactoryBot.create :task }

    it 'リクエストが成功すること' do
      delete task_url task
      expect(response.status).to eq(302)
    end

    it 'タスク名が削除されること' do
      expect do
        delete task_url task
      end.to change(Task, :count).by(-1)
    end

    it 'タスク一覧画面にリダイレクトされること' do
      delete task_url task
      expect(response).to redirect_to tasks_path
    end
  end
end
