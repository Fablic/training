require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:login_admin_user) { create(:user, login_admin_user_data) }
  let(:login_admin_user_data) do
    {
      email: 'test@example.co.jp',
      password: 'password',
      admin: true
    }
  end

  let(:number_of_multiple_data) { 5 }

  before do
    post login_path, params: { session: login_admin_user_data }
  end

  shared_examples_for '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること' do
    it {
      delete logout_path

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
    }
  end

  shared_examples_for 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること' do |message|
    it {
      subject.call
      expect(response).to redirect_to admin_users_path
      expect(flash[:notice]).to match(/^#{message}$/)
    }
  end

  describe 'GET #index' do
    context 'メイン画面にアクセスした場合', bullet: :skip do
      subject { proc { get admin_users_path } }

      it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

      it 'ユーザ管理画面が表示されていること' do
        subject.call
        expect(response.body).to include I18n.t('admin.users.index.page_title')
      end
    end
  end

  describe 'GET #new' do
    subject { proc { get new_admin_user_path } }

    it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

    it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

    it 'ユーザ新規作成画面が表示されていること' do
      subject.call
      expect(response.body).to include I18n.t('admin.users.new.page_title')
    end
  end

  describe 'GET #create' do
    subject { proc { post admin_users_path, params: { user: input_user } } }

    context '有効なパラメータの場合' do
      let(:input_user) { attributes_for(:user) }

      it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

      it 'ユーザが作成されること' do
        subject.call
        expect { subject.call }.to change(User, :count).by(1)
        expect(User.find(User.last.id).name).to eq(input_user[:name])
      end

      it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.create')
    end

    context '無効なパラメータの場合' do
      let(:input_user) { attributes_for(:user, name: nil) }

      it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

      it 'ユーザが作成されないこと' do
        expect { subject.call }.to change(User, :count).by(0)
      end

      it 'ユーザ作成画面へリダイレクトされ、フラッシュメッセージが表示されること' do
        subject.call
        expect(response).to redirect_to new_admin_user_path(input_user[:id])
        expect(flash[:notice]).to match(/^#{I18n.t('admin.users.flash.failure.create')}$/)
      end
    end
  end

  describe 'GET #show' do
    subject { proc { get admin_user_path(id) } }

    context '該当するタスクが存在する場合' do
      let!(:userA) { create(:user) }
      let!(:task_userA01) { create(:task, user: userA, title: 'tasks_for_A01') }
      let!(:task_userA02) { create(:task, user: userA, title: 'tasks_for_A02') }

      let!(:userB) { create(:user) }
      let!(:task_userB01) { create(:task, user: userB, title: 'tasks_for_B01') }
      let!(:task_userB02) { create(:task, user: userB, title: 'tasks_for_B02') }

      context '有効なパラメータの場合' do
        context 'ユーザAのタスク件数リンクを押下した場合' do
          let(:id) { userA.id }

          it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'タスク一覧画面に、選択したユーザ(ユーザA)に紐づくタスク一覧が表示されること' do
            subject.call
            expect(response.body).to include I18n.t('admin.users.show.page_title', user_name: userA.name)

            expect(response.body).to include task_userA01.title
            expect(response.body).to include task_userA02.title
            expect(response.body).not_to include task_userB01.title
            expect(response.body).not_to include task_userB02.title
          end
        end

        context 'ユーザBのタスク件数リンクを押下した場合' do
          let(:id) { userB.id }

          it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

          it 'タスク一覧画面に、選択したユーザ(ユーザB)に紐づくタスク一覧が表示されること' do
            subject.call
            expect(response.body).to include I18n.t('admin.users.show.page_title', user_name: userB.name)

            expect(response.body).not_to include task_userA01.title
            expect(response.body).not_to include task_userA02.title
            expect(response.body).to include task_userB01.title
            expect(response.body).to include task_userB02.title
          end
        end
      end

      context '無効なパラメータの場合' do
        let(:id) { nil }

        it_behaves_like '想定エラーが発生すること', ActionController::UrlGenerationError
      end
    end
  end

  describe 'GET #edit' do
    subject { proc { get edit_admin_user_path(id) } }

    context '該当するユーザが存在する場合' do
      context '有効なパラメータの場合' do
        let(:id) { login_admin_user.id }

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 200

        it 'ユーザ編集画面が表示されていること' do
          subject.call
          expect(response.body).to include I18n.t('admin.users.edit.page_title', user_name: login_admin_user.name)
        end
      end

      context '無効なパラメータの場合' do
        let(:id) { nil }

        it_behaves_like '想定エラーが発生すること', ActionController::UrlGenerationError
      end
    end

    context '該当するユーザが存在しない場合' do
      let(:id) { User.last.id + 1 }

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end

  describe 'PATCH #update' do
    subject { proc { patch admin_user_path(id), params: { user: input_user } } }

    context '該当するユーザが存在する場合' do
      context '有効なパラメータの場合' do
        let(:input_user) { attributes_for(:user, id: id, name: 'updated_user', admin: admin) }

        context '編集対象ユーザが現在ログインしているユーザの場合' do
          let(:id) { login_admin_user.id }

          context '管理ユーザが1人である場合' do
            context '管理権限を変更する場合(一般ユーザへ変更)' do
              let(:admin) { false }

              it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

              it '管理者ユーザが不在となってしまう為、ユーザ情報が更新されないこと' do
                subject.call
                expect(login_admin_user.reload.name).not_to eq 'updated_user'
              end

              it 'ユーザ編集画面へリダイレクトされ、フラッシュメッセージが表示されること' do
                subject.call
                expect(response).to redirect_to edit_admin_user_path(login_admin_user)
                expect(flash[:notice]).to match(/^#{I18n.t('admin.users.flash.failure.update')}$/)
              end
            end

            context '管理権限以外を変更する場合(管理ユーザのまま)' do
              let(:admin) { true }

              it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

              it 'ユーザ情報が更新されること' do
                subject.call
                expect(login_admin_user.reload.name).to eq 'updated_user'
              end

              it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.update')
            end
          end

          context '管理ユーザが複数人(1人以上)である場合' do
            let!(:admin_user02) { create(:user, admin: true) }

            context '管理権限を変更する場合(一般ユーザへ変更)' do
              let(:admin) { false }

              it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

              it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

              it '管理者ユーザが他に1名存在する為、ユーザ情報が更新されること' do
                subject.call
                expect(login_admin_user.reload.name).to eq 'updated_user'
              end
            end

            context '管理権限以外を変更する場合(管理ユーザのまま)' do
              let(:admin) { true }

              it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

              it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

              it 'ユーザ情報が更新されること' do
                subject.call
                expect(login_admin_user.reload.name).to eq 'updated_user'
              end

              it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.update')
            end
          end
        end

        context '編集対象ユーザが現在ログインしているユーザ以外の場合' do
          let!(:user02) { create(:user) }
          let(:id) { user02.id }
          let(:admin) { false }

          it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

          it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

          it 'ユーザ情報が更新されること' do
            subject.call
            expect(user02.reload.name).to eq 'updated_user'
          end

          it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.update')
        end
      end

      context '無効なパラメータの場合' do
        let(:id) { login_admin_user.id }
        let(:input_user) { { name: nil } }

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

        it 'ユーザ情報が更新されないこと' do
          subject.call
          expect(login_admin_user.reload.name).not_to eq nil
        end

        it 'ユーザ編集画面へリダイレクトされ、フラッシュメッセージが表示されること' do
          subject.call
          expect(response).to redirect_to edit_admin_user_path(login_admin_user)
          expect(flash[:notice]).to match(/^#{I18n.t('admin.users.flash.failure.update')}$/)
        end
      end
    end

    context '該当するユーザが存在しない場合' do
      let(:id) { User.last.id + 1 }
      let(:input_user) { attributes_for(:user, name: 'updated_user') }

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end

  describe 'DELETE #destroy' do
    subject { proc { delete admin_user_path(id) } }

    context '該当するユーザが存在する場合' do
      context '削除対象ユーザが現在ログインしているユーザである場合' do
        let(:id) { login_admin_user.id }
        let!(:tasks_user) { create_list(:task, 2, user: login_admin_user) }

        it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

        context '管理ユーザが1人である場合' do
          it '管理者ユーザが不在となってしまう為、ユーザが削除されないこと' do
            expect { subject.call }.to change(User, :count).by(0)
            expect { User.find(id) }.not_to raise_error(ActiveRecord::RecordNotFound)
          end

          it '削除対象ユーザに紐づくタスクが削除されないこと' do
            expect(Task.where(user_id: id).count).to eq 2

            subject.call
            expect(Task.where(user_id: id).count).to eq 2
          end

          it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.failure.destroy')
        end

        context '管理ユーザが複数人(1人以上)である場合' do
          let!(:admin_user02) { create(:user, admin: admin) }
          let(:admin) { true }
          let!(:tasks_admin_user02) { create_list(:task, 2, user: admin_user02) }

          it 'ユーザが削除されること' do
            expect { subject.call }.to change(User, :count).by(-1)
            expect { User.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it '削除対象ユーザに紐づくタスクが削除されること' do
            expect(Task.where(user_id: id).count).to eq 2
            expect(Task.where(user_id: admin_user02.id).count).to eq 2

            subject.call
            expect(Task.where(user_id: id).count).to eq 0
            expect(Task.where(user_id: admin_user02.id).count).to eq 2
          end

          it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.destroy')
        end
      end

      context '削除対象ユーザが現在ログインしているユーザ以外の場合' do
        let!(:user02) { create(:user) }
        let(:id) { user02.id }
        let!(:tasks_user02) { create_list(:task, 2, user: user02) }

        it_behaves_like '管理ユーザがログインしていない場合、ログイン画面にリダイレクトされること'

        it_behaves_like 'レスポンス(HTTPステータスコード)が想定通りであること', 302

        it 'ユーザが削除されること' do
          expect { subject.call }.to change(User, :count).by(-1)
          expect { User.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it '削除対象ユーザに紐づくタスクが削除されること' do
          expect(Task.where(user_id: id).count).to eq 2

          subject.call
          expect(Task.where(user_id: id).count).to eq 0
        end

        it_behaves_like 'ユーザ一覧画面へリダイレクトされ、フラッシュメッセージが表示されること', I18n.t('admin.users.flash.success.destroy')
      end
    end

    context '該当するユーザが存在しない場合' do
      let(:id) { User.last.id + 1 }

      it_behaves_like '想定エラーが発生すること', ActiveRecord::RecordNotFound
    end
  end
end
