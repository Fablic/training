require 'rails_helper'

RSpec.describe TasksController, type: :request do
  let(:user) { FactoryBot.create :user }
  let(:task) { FactoryBot.create :task, user_id: user.id }

  describe 'GET index' do
    before do
      second_user = create(:user, email: 'test2@example.com')
      create(:task, user_id: user.id)
      create(:task, name: 'タスク名2', description: '詳しい説明2', status: 'done', user_id: user.id)
      create(:task, name: 'タスク名3', description: '詳しい説明3', status: 'doing', user_id: second_user.id)
    end

    context 'ログイン中' do
      before { log_in_as user }

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

      it '異なるユーザで作成したタスクが表示されていないこと' do
        get tasks_url
        expect(response.body).not_to include 'タスク名3'
      end

      it '異なるユーザで作成したタスク詳細が表示されていないこと' do
        get tasks_url
        expect(response.body).not_to include '詳しい説明3'
      end
    end

    context 'ログアウト中' do
      it 'リクエストが成功すること' do
        get tasks_url
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        get tasks_url
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET new' do
    context 'ログイン中' do
      before { log_in_as user }

      it 'リクエストが成功すること' do
        get new_task_url
        expect(response.status).to eq(200)
      end

      it 'Task Registration Pageが表示されること' do
        get new_task_url
        expect(response.body).to include 'Task Registration Page'
      end
    end

    context 'ログアウト中' do
      it 'リクエストが成功すること' do
        get new_task_url
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        get new_task_url
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET edit' do
    context 'ログイン中' do
      before { log_in_as user }

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
    end

    context 'ログアウト中' do
      it 'リクエストが成功すること' do
        get edit_task_url task
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        get edit_task_url task
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET show' do
    context 'ログイン中' do
      before { log_in_as user }

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

    context 'ログアウト中' do
      it 'リクエストが成功すること' do
        get task_url task
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        get task_url task
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'POST create' do
    context 'ログイン中' do
      before { log_in_as user }

      context '登録が成功する場合' do
        let(:task_attributes) { FactoryBot.build(:task, user_id: user.id).attributes }

        it 'リクエストが成功すること' do
          post tasks_url, params: { task: task_attributes }
          expect(response.status).to eq(302)
        end

        it 'タスクが1件登録されること' do
          expect do
            post tasks_url, params: { task: task_attributes }
          end.to change(Task, :count).by(1)
        end

        it 'タスク一覧画面にリダイレクトされること' do
          post tasks_url, params: { task: task_attributes }
          expect(response).to redirect_to tasks_path
        end
      end

      context '登録が成功しない場合' do
        let(:task_attributes) { FactoryBot.build(:task, :invalid, user_id: user.id).attributes }

        it 'リクエストが成功すること' do
          post tasks_url, params: { task: task_attributes }
          expect(response.status).to eq(200)
        end

        it 'タスクが登録されないこと' do
          expect do
            post tasks_url, params: { task: task_attributes }
          end.to_not change(Task, :count)
        end

        it 'エラーが表示されること' do
          post tasks_url, params: { task: task_attributes }
          expect(response.body).to include 'タスク名を入力してください'
        end
      end
    end

    context 'ログアウト中' do
      let(:task_attributes) { FactoryBot.build(:task, user_id: user.id).attributes }
      it 'リクエストが成功すること' do
        post tasks_url, params: { task: task_attributes }
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        post tasks_url, params: { task: task_attributes }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'PUT update' do
    context 'ログイン中' do
      before { log_in_as user }

      context '更新が成功する場合' do
        let(:task_attributes) { FactoryBot.build(:task, name: '更新後タスク名', description: 'より詳しい説明', status: 'done', user_id: user.id).attributes }

        it 'リクエストが成功すること' do
          put task_url task, params: { task: task_attributes }
          expect(response.status).to eq(302)
        end

        it '更新後、タスク一覧画面にリダイレクトされること' do
          put task_url task, params: { task: task_attributes }
          expect(response).to redirect_to tasks_path
        end

        it 'タスク名が更新されること' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to change { Task.find(task.id).name }.from('タスク名').to('更新後タスク名')
        end

        it 'タスク詳細が更新されること' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to change { Task.find(task.id).description }.from('詳しい説明').to('より詳しい説明')
        end

        it 'ステータスが更新されること' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to change { Task.find(task.id).status }.from('todo').to('done')
        end
      end

      context '登録が成功しない場合' do
        let(:task_attributes) { FactoryBot.build(:task, :invalid, description: 'より詳しい説明', status: 'done', user_id: user.id).attributes }

        it 'リクエストが成功すること' do
          put task_url task, params: { task: task_attributes }
          expect(response.status).to eq(200)
        end

        it 'タスク名が変更されないこと' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to_not change(Task.find(task.id), :name)
        end

        it 'タスク詳細が変更されないこと' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to_not change(Task.find(task.id), :description)
        end

        it 'ステータスが変更されないこと' do
          expect do
            put task_url task, params: { task: task_attributes }
          end.to_not change(Task.find(task.id), :status)
        end

        it 'エラーが表示されること' do
          put task_url task, params: { task: task_attributes }
          expect(response.body).to include 'タスク名を入力してください'
        end
      end
    end

    context 'ログアウト中' do
      let(:task_attributes) { FactoryBot.build(:task, name: '更新後タスク名', description: 'より詳しい説明', status: 'done', user_id: user.id).attributes }

      it 'リクエストが成功すること' do
        put task_url task, params: { task: task_attributes }
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        put task_url task, params: { task: task_attributes }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:task) { FactoryBot.create :task, user_id: user.id }

    context 'ログイン中' do
      before { log_in_as user }

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
    context 'ログアウト中' do
      it 'リクエストが成功すること' do
        delete task_url task
        expect(response.status).to eq(302)
      end

      it 'ログインページにリダイレクトされること' do
        delete task_url task
        expect(response).to redirect_to login_url
      end
    end
  end
end
