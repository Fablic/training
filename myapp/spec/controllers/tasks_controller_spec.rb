require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user) { create(:user) }
  let(:number_of_multiple_data) { 5 }

  before do
    session[:user_id] = user.id
  end

  shared_examples_for 'ログインしていない場合、ログイン画面にリダイレクトされること' do
    it {
      session.delete(:user_id)

      subject.call
      expect(response).to redirect_to login_path
    }
  end

  shared_examples_for 'レスポンス(HTTPステータスコード)が想定通りであること' do |status|
    it {
      subject.call
      expect(response).to have_http_status(status)
    }
  end

  shared_examples_for '想定エラーが発生すること' do |error|
    it {
      expect { subject.call }.to raise_error(error)
      expect(response.response_code).to eq(200)
    }
  end

  shared_examples_for 'input_search_paramsでのバリデーションにより値が無効化され、検索条件の指定なく全てのデータを取得していること' do
    it {
      subject.call
      search_params = controller.instance_variable_get('@search_params')
      expect(search_params.present?).to eq false
      displayed_tasks = controller.instance_variable_get('@tasks')
      expect(displayed_tasks.size).to be == number_of_multiple_data
    }
  end

  describe 'GET #index' do
    context 'メイン画面にアクセスした場合' do
      subject { proc { get :index } }

      let!(:tasks) { create_list(:task, number_of_multiple_data, user: user) }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it '作成日時(新しい順)で並び替えられた全てのデータを取得していること' do
        subject.call
        displayed_tasks = controller.instance_variable_get('@tasks')
        expect(displayed_tasks.size).to be == number_of_multiple_data

        before_task = nil
        displayed_tasks.each do |task|
          expect(task.send(:created_at)).to be <= before_task.send(:created_at) if before_task
          before_task = task
        end
      end
    end
  end

  describe 'GET #sort' do
    subject { proc { get :sort, params: param } }

    let!(:tasks) { create_list(:task, number_of_multiple_data, user: user) }

    context '終了期日(新しい順)が選択された場合' do
      let(:param) { { termination_at_latest: true } }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it '終了期日(新しい順)で並び替えられた全てのデータを取得していること' do
        subject.call
        displayed_tasks = controller.instance_variable_get('@tasks')
        expect(displayed_tasks.size).to be == number_of_multiple_data

        before_task = nil
        displayed_tasks.each do |task|
          expect(task.send(:termination_at)).to be <= before_task.send(:termination_at) if before_task
          before_task = task
        end
      end
    end

    context '終了期日(古い順)が選択された場合' do
      let(:param) { { termination_at_oldest: true } }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it '終了期日(古い順)で並び替えられた全てのデータを取得していること' do
        subject.call
        displayed_tasks = controller.instance_variable_get('@tasks')
        expect(displayed_tasks.size).to be == number_of_multiple_data

        before_task = nil
        displayed_tasks.each do |task|
          expect(task.send(:termination_at)).to be >= before_task.send(:termination_at) if before_task
          before_task = task
        end
      end
    end
  end

  describe 'GET #search' do
    subject { proc { get :search, params: params } }

    let!(:tasks) { create_list(:task, number_of_multiple_data, user: user) }
    let(:params) { { search: input_value } }

    context '検索条件に値が入力されている場合' do
      let(:search_text) { 'test_title_for_search' }

      context '正しい値が入力されている場合' do
        let!(:task_for_search) { create(:task, :with_label, task_data_for_search) }

        context 'タイトル、ステータス、ラベルIDが入力されている場合' do
          let(:input_value) do
            {
              title: search_text,
              status: Task.statuses[:not_started],
              label_id: task_for_search.labels[0].id,
              user: user
            }
          end

          let(:task_data_for_search) do
            {
              title: search_text,
              status: Task.statuses[:not_started],
              user: user
            }
          end

          it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'input_search_paramsによるバリデーション後の値を使用し、検索条件に一致するデータを1件(ラベル2つ設定)取得していること' do
            subject.call
            search_params = controller.instance_variable_get('@search_params')
            expect(search_params.present?).to eq true
            expect(search_params[:title]).to eq input_value[:title]
            expect(search_params[:status]).to eq input_value[:status].to_s
            expect(search_params[:label_id]).to eq input_value[:label_id].to_s
            displayed_tasks = controller.instance_variable_get('@tasks')
            expect(displayed_tasks.size).to be == 1
            expect(displayed_tasks[0].title).to eq task_for_search.title
            expect(displayed_tasks[0].status).to eq task_for_search.status
            expect(displayed_tasks[0].labels[0].name).to eq task_for_search.labels[0].name
            expect(displayed_tasks[0].labels[1].name).to eq task_for_search.labels[1].name
          end
        end

        context 'タイトルのみ入力されている場合' do
          let(:input_value) do
            {
              title: search_text,
              user: user
            }
          end

          let(:task_data_for_search) { input_value.dup }

          it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'input_search_paramsによるバリデーション後の値を使用し、検索条件に一致するデータを1件取得していること' do
            subject.call
            search_params = controller.instance_variable_get('@search_params')
            expect(search_params.present?).to eq true
            expect(search_params[:title]).to eq input_value[:title]
            expect(search_params[:status]).to eq nil
            expect(search_params[:label_id]).to eq nil
            displayed_tasks = controller.instance_variable_get('@tasks')
            expect(displayed_tasks.size).to be == 1
            expect(displayed_tasks[0].title).to eq task_for_search.title
            expect(displayed_tasks[0].status).to eq task_for_search.status
          end
        end

        context 'ステータスのみ入力されている場合' do
          let(:input_value) do
            {
              status: Task.statuses[:done],
              user: user
            }
          end

          let(:task_data_for_search) { input_value.dup }

          it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'input_search_paramsによるバリデーション後の値を使用し、検索条件に一致するデータを1件取得していること' do
            subject.call
            search_params = controller.instance_variable_get('@search_params')
            expect(search_params.present?).to eq true
            expect(search_params[:title]).to eq nil
            expect(search_params[:status]).to eq input_value[:status].to_s
            expect(search_params[:label_id]).to eq nil
            displayed_tasks = controller.instance_variable_get('@tasks')
            expect(displayed_tasks.size).to be == 1
            expect(displayed_tasks[0].title).to eq task_for_search.title
            expect(displayed_tasks[0].status).to eq task_for_search.status
          end
        end

        context 'ラベルIDのみ入力されている場合' do
          let(:input_value) do
            {
              label_id: task_for_search.labels[0].id,
              user: user
            }
          end

          let(:task_data_for_search) { { user: user } }

          it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'input_search_paramsによるバリデーション後の値を使用し、検索条件に一致するデータを1件(ラベル2つ設定)取得していること' do
            subject.call
            search_params = controller.instance_variable_get('@search_params')
            expect(search_params.present?).to eq true
            expect(search_params[:title]).to eq nil
            expect(search_params[:status]).to eq nil
            expect(search_params[:label_id]).to eq input_value[:label_id].to_s
            displayed_tasks = controller.instance_variable_get('@tasks')
            expect(displayed_tasks.size).to be == 1
            expect(displayed_tasks[0].title).to eq task_for_search.title
            expect(displayed_tasks[0].status).to eq task_for_search.status
            expect(displayed_tasks[0].labels[0].name).to eq task_for_search.labels[0].name
            expect(displayed_tasks[0].labels[1].name).to eq task_for_search.labels[1].name
          end
        end
      end

      context '不正な値が入力されている場合' do
        let(:input_value) do
          {
            unknown01: search_text,
            unknown02: Task.statuses[:not_started]
          }
        end

        it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

        it_behaves_like 'input_search_paramsでのバリデーションにより値が無効化され、検索条件の指定なく全てのデータを取得していること'
      end
    end

    context '検索条件に値が入力されていない場合' do
      let(:input_value) { {} }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it_behaves_like 'input_search_paramsでのバリデーションにより値が無効化され、検索条件の指定なく全てのデータを取得していること'
    end
  end

  describe 'GET #new' do
    subject { proc { get :new } }

    it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

    it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200
  end

  describe 'GET #show' do
    subject { proc { get :show, params: { id: id } } }

    let!(:task) { create(:task, user: user) }

    context '該当するタスクが存在する場合' do
      context '有効なパラメータの場合' do
        let(:id) { task.id }

        it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200
      end

      context '無効なパラメータの場合' do
        let(:id) { nil }

        it_behaves_like '想定エラーが発生すること', ActionController::UrlGenerationError
      end
    end

    context '該当するタスクが存在しない場合' do
      let(:id) { Task.last.id + 1 }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end

  describe 'GET #edit' do
    subject { proc { get :edit, params: { id: id } } }

    let!(:task) { create(:task, user: user) }

    context '該当するタスクが存在する場合' do
      context '有効なパラメータの場合' do
        let(:id) { task.id }

        it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200
      end

      context '無効なパラメータの場合' do
        let(:id) { nil }

        it_behaves_like '想定エラーが発生すること', ActionController::UrlGenerationError
      end
    end

    context '該当するタスクが存在しない場合' do
      let(:id) { Task.last.id + 1 }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end

  describe 'POST #create' do
    subject { proc { post :create, params: { task: task } } }

    context '有効なパラメータの場合' do
      let(:task) { attributes_for(:task, title: 'test_title_create') }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

      it 'タスクが作成されること' do
        expect { subject.call }.to change(Task, :count).by(1)
        expect(Task.find(Task.last.id).title).to eq('test_title_create')
      end

      it '作成したタスク詳細画面へリダイレクトされ、フラッシュメッセージが表示されること' do
        subject.call
        expect(response).to redirect_to "/#{Task.last.id}"
        expect(flash[:notice]).to match(/^#{I18n.t('tasks.flash.new')}$/)
      end
    end

    context '無効なパラメータの場合' do
      let(:task) { attributes_for(:task, title: nil) }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it 'タスクが作成されないこと' do
        expect { subject.call }.to change(Task, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    subject { proc { patch :update, params: { id: id, task: { title: value } } } }

    let!(:task) { create(:task, user: user) }

    context '該当するタスクが存在する場合' do
      let(:id) { task.id }

      context '有効なパラメータの場合' do
        let(:value) { 'updated_task' }

        it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

        it 'タスク情報が更新されること' do
          subject.call
          expect(task.reload.title).to eq 'updated_task'
        end

        it '更新したタスク詳細画面へリダイレクトされ、フラッシュメッセージが表示されること' do
          subject.call
          expect(response).to redirect_to "/#{task.id}"
          expect(flash[:notice]).to match(/^#{I18n.t('tasks.flash.update')}$/)
        end
      end

      context '無効なパラメータの場合' do
        let(:value) { nil }

        it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

        it 'タスク情報が更新されないこと' do
          subject.call
          expect(task.reload.title).not_to eq nil
        end
      end
    end

    context '該当するタスクが存在しない場合' do
      let(:id) { Task.last.id + 1 }
      let(:value) { 'updated_task' }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end

  describe 'DELETE #destroy' do
    subject { proc { delete :destroy, params: { id: id } } }

    let!(:tasks) { create_list(:task, 2, :with_label, user: user) }

    context '該当するタスクが存在する場合' do
      let(:id) { tasks[0].id }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

      it 'タスクが削除されること' do
        expect { subject.call }.to change(Task, :count).by(-1)
        expect { Task.find(tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Task.find(tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'タスクに紐づく中間データ(TasksLabel)2件が削除されること' do
        expect { subject.call }.to change(TasksLabel, :count).by(-2)
        expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { TasksLabel.find_by!(task_id: tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'タスク一覧画面へリダイレクトされ、フラッシュメッセージが表示されること' do
        subject.call
        expect(response).to redirect_to '/'
        expect(flash[:notice]).to match(/^#{I18n.t('tasks.flash.destroy')}$/)
      end
    end

    context '該当するタスクが存在しない場合' do
      let(:id) { Task.last.id + 1 }

      it_behaves_like 'ログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end
end
