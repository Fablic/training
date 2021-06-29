require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:lowTaskPriority) { create(:low) }
  let(:middleTaskPriority) { create(:middle) }
  let(:notStartedTaskStatus) { create(:notStarted) }
  let!(:task) { create(:task) }

  describe '#index' do
    it 'レスポンスが正常' do
      get :index
      expect(response).to be_successful
    end
    it 'レスポンスのステータスが200' do
      get :index
      expect(response).to have_http_status :success
    end
    it 'テンプレートが表示されている' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    it 'レスポンスが正常' do
      get :show, params: {id: task.id}
      expect(response).to be_successful
    end
    it 'レスポンスのステータスが200' do
      get :show, params: {id: task.id}
      expect(response).to have_http_status :success
    end
    it 'テンプレートが表示されている' do
      get :show, params: {id: task.id}
      expect(response).to render_template :show
    end
  end

  describe '#new' do
    it 'レスポンスが正常' do
      get :new
      expect(response).to be_successful
    end
    it 'レスポンスのステータスが200' do
      get :new
      expect(response).to have_http_status :success
    end
    it 'テンプレートが表示されている' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe '#edit' do
    it 'レスポンスが正常' do
      get :edit, params: {id: task.id}
      expect(response).to be_successful
    end
    it 'レスポンスのステータスが200' do
      get :edit, params: {id: task.id}
      expect(response).to have_http_status :success
    end
    it 'テンプレートが表示されている' do
      get :edit, params: {id: task.id}
      expect(response).to render_template :edit
    end
  end

  describe '#create' do
    context '正常な値' do
      let(:newTask) { { task_name: '新規作成テストタスク', priority_id: lowTaskPriority } }
      it '正常にタスクを作成できること' do
        expect {
          post :create, params: { task: newTask }
        }.to change(Task, :count).by(1)
      end
      it '新規作成後、詳細ページにリダイレクトされること' do
        post :create, params: { task: newTask }
        expect(response).to redirect_to "/tasks/#{ Task.last.id }"
      end
    end
    context '不正な値' do
      let(:unjustNewTask) { { task_name: '新規作成テストタスク', priority: nil} }
      it 'タスクが作成されないこと' do
        expect {
          post :create, params: { task: unjustNewTask }
        }.to change(Task, :count).by(0)
      end
      it '新規作成ページが表示されること' do
        post :create, params: { task: unjustNewTask }
        expect(response).to render_template :new
      end
    end
  end

  describe '#update' do
    context '正常な値' do
      let(:normalTaskParams) { { task_name: '変更後テストタスク名', status_id: notStartedTaskStatus, priority_id: lowTaskPriority } }
      it '正常にタスクを更新できること' do
        task_params = normalTaskParams
          patch :update, params: {id: task.id, task: task_params}
          expect(task.reload.task_name).to eq '変更後テストタスク名'
      end
      it '更新後、詳細ページにリダイレクトされること' do
        task_params = normalTaskParams
          patch :update, params: {id: task.id, task: task_params}
          expect(response).to redirect_to "/tasks/#{ task.id }"
      end 
    end
    context '不正な値' do
      let(:unjustTaskParams) { { task_name: '変更後テストタスク名', status_id: 4, priority_id: lowTaskPriority } }
      it 'タスクを更新できないこと' do
        task_params = unjustTaskParams
          patch :update, params: {id: task.id, task: task_params}
          expect(task.reload.status).to eq notStartedTaskStatus
      end
      it '更新ページが表示されること' do
        task_params = unjustTaskParams
          patch :update, params: {id: task.id, task: task_params}
          expect(response).to render_template :edit
      end
    end
  end

  describe '#destroy' do
    it '正常にタスクを論理削除できること' do
        patch :destroy, params: {id: task.id}
        expect(task.reload.deleted_at).to_not eq nil
    end
    it '削除後、一覧ページにリダイレクトされること' do
        patch :destroy, params: {id: task.id}
        expect(response).to redirect_to '/tasks'
    end 
  end
end
