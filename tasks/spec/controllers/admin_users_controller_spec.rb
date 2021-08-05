require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
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

  describe '#show' do
    context 'ログイン状態の場合' do
      include_context 'login_and_create_task_link'
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :show, params: { id: user.id }
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
        get :show, params: { id: user.id }
        expect(assigns(:tasks)).to match task_list_default
      end
    end
    context '2ページ目の表示の場合' do
      let(:task_list_next_page) do
        sort_list = default_sort(task_list)
        sort_list[Task.default_per_page, Task.default_per_page * 2]
      end
      it '2ページ目には、作成日時の降順で、作成日時が最も古い2件表示されること' do
        get :show, params: { id: user.id, page: 2 }
        expect(assigns(:tasks)).to match task_list_next_page
      end
    end
  end

  describe '#edit' do
    context 'ログイン状態の場合' do
      before { log_in(user) }
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :edit, params: { id: user.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
      end
    end
    context 'ログアウト状態の場合' do
      it 'ログインページにリダイレクトされること' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#update' do
    before { log_in(user) }
    context '正常な値' do
      let(:normal_user_params) { { user_name: '変更後ユーザ名', email: 'update@user.com' } }
      it '正常にタスクを更新できること' do
        patch :update, params: { id: user.id, user: normal_user_params }
        expect(user.reload.user_name).to eq '変更後ユーザ名'
        expect(user.email).to eq 'update@user.com'
      end
      it '更新後、詳細ページにリダイレクトされること' do
        patch :update, params: { id: user.id, user: normal_user_params }
        expect(response).to redirect_to admin_user_path(id: user.id)
      end
    end
    context '不正な値' do
      let!(:before_update_user) { user }
      let(:unjust_user_params) { { user_name: '変更後ユーザ名', email: nil } }
      it 'ユーザを更新できないこと' do
        patch :update, params: { id: user.id, user: unjust_user_params }
        expect(user.reload.user_name).to eq before_update_user.user_name
        expect(user.email).to eq before_update_user.email
      end
      it '更新ページが表示されること' do
        patch :update, params: { id: user.id, user: unjust_user_params }
        expect(response).to render_template :edit
      end
    end
  end

  describe '#destroy' do
    include_context 'login_and_create_task_link'
    context '別のユーザを削除しようとした場合' do
      let!(:other_user) { create(:user_after_create_task) }
      it '正常にユーザが論理削除できること' do
        patch :destroy, params: { id: other_user.id }
        expect(other_user.reload.deleted_at).to be_present
      end
      it '正常にそのユーザのタスクが論理削除できること' do
        patch :destroy, params: { id: other_user.id }
        expect(other_user.tasks[0].reload.deleted_at).to be_present
      end
      it '削除後、一覧ページにリダイレクトされること' do
        patch :destroy, params: { id: user.id }
        expect(response).to redirect_to admin_users_path
      end
    end
    context 'ログイン中の自身のユーザを削除しようとした場合' do
      it 'そのユーザは論理削除されないこと' do
        patch :destroy, params: { id: user.id }
        expect(user.reload.deleted_at).to eq nil
      end
      it 'そのユーザのタスクは論理削除されないこと' do
        patch :destroy, params: { id: user.id }
        expect(user.tasks[0].reload.deleted_at).to eq nil
      end
      it '一覧ページにリダイレクトすること' do
        patch :destroy, params: { id: user.id }
        expect(response).to redirect_to admin_users_path
      end
    end
    context 'update中にエラーが発生した場合' do
      let!(:other_user) { create(:user_after_create_task) }
      before do
        allow_any_instance_of(User).to receive(:update!).and_raise(RuntimeError)
      end
      it 'そのユーザは論理削除されないこと' do
        patch :destroy, params: { id: other_user.id }
        expect(other_user.reload.deleted_at).to eq nil
      end
      it 'そのユーザのタスクは論理削除されないこと' do
        patch :destroy, params: { id: other_user.id }
        expect(other_user.tasks[0].reload.deleted_at).to eq nil
      end
      it '一覧ページにリダイレクトすること' do
        patch :destroy, params: { id: other_user.id }
        expect(response).to redirect_to admin_users_path
      end
    end
  end

  private

  def default_sort(target_list)
    target_list.sort_by(&:created_at).reverse
  end
end
