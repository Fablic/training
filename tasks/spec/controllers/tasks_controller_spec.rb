require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:lowTaskPriority) { create(:low) }
  let(:notStartedTaskStatus) { create(:notStarted) }
  let!(:task) { create(:task) }

  describe '#index' do
    context 'レスポンスが正常の時' do
      let(:task_list) do
        [
          create(:task_list_item),
          create(:task_list_item, created_at: Time.current + 1.day),
          create(:task_list_item, created_at: Time.current + 2.days),
          create(:task_list_item, deleted_at: Time.current)
        ]
      end
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :index
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :index
      end
      it '作成日時の降順かつ、論理削除されていないタスクのみの一覧が取得されること' do
        get :index
        expect(Task.without_deleted.created_at_desc).to match [task_list[2], task_list[1], task_list[0], task]
      end
    end
  end

  describe '#show' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :show, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :show
      end
    end
  end

  describe '#new' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :new
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :new
      end
    end
  end

  describe '#edit' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :edit, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
      end
    end
  end

  describe '#create' do
    context '正常な値' do
      let(:newTask) { { task_name: '新規作成テストタスク', priority_id: lowTaskPriority } }
      it '正常にタスクを作成できること' do
        expect { post :create, params: { task: newTask } }.to change(Task, :count).by(1)
      end
      it '新規作成後、詳細ページにリダイレクトされること' do
        post :create, params: { task: newTask }
        expect(response).to redirect_to "/tasks/#{Task.last.id}"
      end
    end
    context '不正な値' do
      let(:unjustNewTask) { { task_name: '新規作成テストタスク', priority: nil } }
      it 'タスクが作成されないこと' do
        expect { post :create, params: { task: unjustNewTask } }.to change(Task, :count).by(0)
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
        patch :update, params: { id: task.id, task: normalTaskParams }
        expect(task.reload.task_name).to eq '変更後テストタスク名'
      end
      it '更新後、詳細ページにリダイレクトされること' do
        task_params = normalTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to redirect_to "/tasks/#{task.id}"
      end
    end
    context '不正な値' do
      let(:unjustTaskParams) { { task_name: '変更後テストタスク名', status_id: 4, priority_id: lowTaskPriority } }
      it 'タスクを更新できないこと' do
        task_params = unjustTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(task.reload.status).to eq notStartedTaskStatus
      end
      it '更新ページが表示されること' do
        task_params = unjustTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to render_template :edit
      end
    end
  end

  describe '#destroy' do
    it '正常にタスクを論理削除できること' do
      patch :destroy, params: { id: task.id }
      expect(task.reload.deleted_at).to_not eq nil
    end
    it '削除後、一覧ページにリダイレクトされること' do
      patch :destroy, params: { id: task.id }
      expect(response).to redirect_to '/tasks'
    end
  end
end
