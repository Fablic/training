require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:lowTaskPriority) { create(:low) }
  let(:notStartedTaskStatus) { create(:notStarted) }
  let(:task) { create(:task_list_item) }
  let(:user) { create(:user) }

  shared_context 'login_and_create_task_link' do
    before do
      create(:task_link, task: task, user: user)
      log_in(user)
    end
  end

  describe '#index' do
    context 'ログイン状態の場合' do
      before { log_in(user) }
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :index
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :index
      end
    end
    context 'ログアウト状態の場合' do
      it 'ログインページにリダイレクトされること' do
        get :index
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '表示されるタスク一覧が、指定した条件に合っているかチェック（検索、絞り込み、ソートの複合処理）' do
    let!(:task_list) do
      [
        create(:task_list_item),
        create(:task_list_item, task_name: 'テスト1', status: create(:started), created_at: Time.current + 1.day, limit_date: Time.current + 5.days),
        create(:task_list_item, task_name: 'タスク1', status: create(:finished), created_at: Time.current + 2.days, limit_date: Time.current + 3.days),
        create(:task_list_item, task_name: 'テスト2', status: create(:notStarted), created_at: Time.current + 3.days, limit_date: Time.current + 6.days),
        create(:task_list_item, task_name: 'タスク2', status: create(:started), created_at: Time.current + 4.days, limit_date: Time.current + 4.days),
        create(:task_list_item, task_name: 'テストタスク1', deleted_at: Time.current, limit_date: Time.current + 2.days)
      ]
    end
    let!(:task_link) do
      [
        create(:task_link, task: task_list[0], user: user),
        create(:task_link, task: task_list[1], user: user),
        create(:task_link, task: task_list[2], user: user),
        create(:task_link, task: task_list[3], user: user),
        create(:task_link, task: task_list[4], user: user),
        create(:task_link, task: task_list[5], user: user)
      ]
    end
    let!(:label_list) do
      [
        create(:label_link, label: create(:label, label_name: 'ああ'), task: task_list[0]),
        create(:label_link, label: create(:label, label_name: 'いい'), task: task_list[1]),
        create(:label_link, label: create(:label, label_name: 'テスト'), task: task_list[2]),
        create(:label_link, label: create(:label, label_name: 'ええ'), task: task_list[3]),
        create(:label_link, label: create(:label, label_name: 'あい'), task: task_list[4]),
        create(:label_link, label: create(:label, label_name: 'うえ'), task: task_list[5])
      ]
    end
    before { log_in(user) }
    context '何も指定がない場合（初期表示）' do
      let(:task_list_default) do
        expect_task_list = task_list.select { |task| task.deleted_at.nil? }
        default_sort(expect_task_list)
      end
      it '論理削除されていない、全てのタスクが、作成日時の降順で取得されること' do
        get :index
        expect(assigns(:tasks)).to match task_list_default
      end
    end
    context '検索欄に「テス」を入力、絞り込みを「未着手」「着手」を選択し、期限の昇順を指定した場合' do
      let(:task_list_search_and_sort) do
        expect_task_list = task_list.select do |task|
          @label = task.labels[0]
          task.deleted_at.nil? && (task.task_name.include?('テス') || @label.label_name.include?('テス')) && (task.status_id == 1 || task.status_id == 2)
        end
        expect_task_list.sort do |a, b|
          if a.limit_date.nil?
            -1
          elsif b.limit_date.nil?
            1
          else
            a.limit_date <=> b.limit_date
          end
        end
      end
      it '論理削除されていない、タスク名に「テス」を含む、ステータスが「未着手」と「着手」の全てのタスクが、期限の昇順で取得されること' do
        get :index, params: { keyword: 'テス', statuses: %w[1 2], direction: 'asc', sort: 'limit_date' }
        expect(assigns(:tasks)).to match task_list_search_and_sort
      end
    end
  end

  describe 'ページネーション' do
    let(:task_list) { create_list(:task_list_item, 12) }
    before do
      log_in(user)
      task_list.each do |task|
        create(:task_link, task: task, user: user)
      end
    end
    context '1ページ目の表示の場合' do
      let(:task_list_default) do
        sort_list = default_sort(task_list)
        sort_list[0, Task.default_per_page]
      end
      it '作成日時の降順で、作成日時が最も新しい10件表示されること' do
        get :index
        expect(assigns(:tasks)).to match task_list_default
      end
    end
    context '2ページ目の表示の場合' do
      let(:task_list_next_page) do
        sort_list = default_sort(task_list)
        sort_list[Task.default_per_page, Task.default_per_page * 2]
      end
      it '2ページ目には、作成日時の降順で、作成日時が最も古い2件表示されること' do
        get :index, params: { page: 2 }
        expect(assigns(:tasks)).to match task_list_next_page
      end
    end
  end

  describe '#show' do
    context 'ログイン状態の場合' do
      include_context 'login_and_create_task_link'
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :show, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :show
      end
    end
    context 'ログアウト状態の場合' do
      it 'ログインページにリダイレクトされること' do
        get :show, params: { id: task.id }
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/login'
      end
    end
    context '別ユーザのタスクの詳細を表示させようとした場合' do
      let!(:other_user) { create(:user_after_create_task, email: 'other@user.jp') }
      include_context 'login_and_create_task_link'
      it '別ユーザのタスクが表示されず、一覧ページにリダイレクトすること' do
        get :show, params: { id: other_user.tasks.ids }
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#new' do
    context 'ログイン状態の場合' do
      before { log_in(user) }
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :new
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :new
      end
    end
    context 'ログアウト状態の場合' do
      it 'ログインページにリダイレクトされること' do
        get :new
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#edit' do
    context 'ログイン状態の場合' do
      include_context 'login_and_create_task_link'
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :edit, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
      end
    end
    context 'ログアウト状態の場合' do
      it 'ログインページにリダイレクトされること' do
        get :edit, params: { id: task.id }
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/login'
      end
    end
    context '別ユーザのタスクの編集画面を表示させようとした場合' do
      let!(:other_user) { create(:user_after_create_task, email: 'other@user.jp') }
      include_context 'login_and_create_task_link'
      it '別ユーザのタスクの編集画面が表示されず、一覧ページにリダイレクトすること' do
        get :edit, params: { id: other_user.tasks.ids }
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context '正常な値' do
      let(:newTask) { { task_name: '新規作成テストタスク', priority_id: lowTaskPriority, status_id: notStartedTaskStatus, label: nil, limit_date: nil, detail: nil } }
      before { log_in(user) }
      it '正常にタスクを作成できること' do
        expect { post :create, params: { task: newTask } }.to change(Task, :count).by(1)
      end
      it '新規作成後、詳細ページにリダイレクトされること' do
        post :create, params: { task: newTask }
        expect(response).to redirect_to task_path(id: Task.last.id)
      end
    end
    context '不正な値' do
      let(:unjustNewTask) { { task_name: '新規作成テストタスク', priority: nil, status_id: notStartedTaskStatus, label: nil, limit_date: nil, detail: nil } }
      before { log_in(user) }
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
    include_context 'login_and_create_task_link'
    context '正常な値' do
      let(:normalTaskParams) { { task_name: '変更後テストタスク名', status_id: notStartedTaskStatus, priority_id: lowTaskPriority, label: '変更後ラベル' } }
      it '正常にタスクを更新できること' do
        patch :update, params: { id: task.id, task: normalTaskParams }
        expect(task.reload.task_name).to eq '変更後テストタスク名'
        expect(task.labels[0].label_name).to eq '変更後ラベル'
      end
      it '更新後、詳細ページにリダイレクトされること' do
        task_params = normalTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to redirect_to task_path(id: task.id)
      end
    end
    context '不正な値' do
      let(:unjustTaskParams) { { task_name: '変更後テストタスク名', status_id: 4, priority_id: lowTaskPriority, label: nil } }
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
    context '別ユーザのタスクを編集しようとした場合' do
      let(:normalTaskParams) { { task_name: '変更後テストタスク名', status_id: notStartedTaskStatus, priority_id: lowTaskPriority } }
      let!(:other_user) { create(:user_after_create_task, email: 'other@user.jp') }
      it '別ユーザのタスクの編集されず、一覧ページにリダイレクトすること' do
        patch :update, params: { id: other_user.tasks[0].id, task: normalTaskParams }
        expect(other_user.tasks[0].task_name).to_not eq '変更後テストタスク名'
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    include_context 'login_and_create_task_link'
    context '自分のユーザのタスクを削除しようとした場合' do
      it '正常にタスクを論理削除できること' do
        patch :destroy, params: { id: task.id }
        expect(task.reload.deleted_at).to_not eq nil
      end
      it '削除後、一覧ページにリダイレクトされること' do
        patch :destroy, params: { id: task.id }
        expect(response).to redirect_to tasks_path
      end
    end
    context '別ユーザのタスクを削除しようとした場合' do
      let!(:other_user) { create(:user_after_create_task, email: 'other@user.jp') }
      it '別ユーザのタスクの削除されず、一覧ページにリダイレクトすること' do
        patch :destroy, params: { id: other_user.tasks[0].id }
        expect(other_user.tasks[0].reload.deleted_at).to eq nil
        expect(response).to redirect_to root_path
      end
    end
  end

  private

  def default_sort(target_list)
    target_list.sort_by(&:created_at).reverse
  end
end
