require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:msg_invalid_email) { I18n.t('sessions.flash.login.invalid_email') }
  let(:msg_invalid_password) { I18n.t('sessions.flash.login.invalid_password') }
  let(:login_page_title) { I18n.t('sessions.new.page_title') }

  shared_examples_for 'レスポンス(HTTPステータスコード)が正しいこと' do |status|
    it {
      subject.call
      expect(response).to have_http_status(status)
    }
  end

  describe 'GET #new' do
    subject { proc { get login_path } }

    it 'ログイン画面に遷移すること' do
      subject.call
      expect(response.body).to include login_page_title
    end

    it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 200
  end

  describe 'POST #create' do
    subject { proc { post login_path, params: { session: input_session_param } } }
    let(:input_session_param) do
      {
        email: input_email,
        password: input_password
      }
    end

    let!(:user_test) { create(:user, email: 'test@example.co.jp', password: 'password') }

    context '正しい値が入力されている場合' do
      context 'ログインに成功する場合' do
        let(:input_email) { 'test@example.co.jp' }
        let(:input_password) { 'password' }

        it 'ログインに成功し、メイン画面(タスク一覧画面)へリダイレクトされること' do
          subject.call
          expect(response).to redirect_to(root_path)
        end

        it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 302
      end

      context 'ログインに失敗する場合' do
        context 'メールアドレスが不正な場合' do
          let(:input_email) { 'wrong_test@example.co.jp' }
          let(:input_password) { 'password' }

          it 'ログインに失敗し、ログイン画面にフラッシュメッセージ(メールアドレスが間違っています)が表示される' do
            subject.call
            expect(response.body).to include login_page_title
            expect(flash[:danger]).to match(/^#{msg_invalid_email}$/)
          end

          it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 200
        end

        context 'パスワードが不正な場合' do
          let(:input_email) { 'test@example.co.jp' }
          let(:input_password) { 'wrong_password' }

          it 'ログインに失敗し、ログイン画面にフラッシュメッセージ(パスワードが間違っています)が表示される' do
            subject.call
            expect(response.body).to include login_page_title
            expect(flash[:danger]).to match(/^#{msg_invalid_password}$/)
          end

          it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 200
        end
      end
    end

    context '不正な値が入力されている場合' do
      let(:input_session_param) do
        {
          unknown01: input_email,
          unknown02: input_password
        }
      end
      let(:input_email) { 'test@example.co.jp' }
      let(:input_password) { 'password' }

      it 'ログインに失敗し、ログイン画面にフラッシュメッセージ(メールアドレスが間違っています)が表示される' do
        subject.call
        expect(response.body).to include login_page_title
        expect(flash[:danger]).to match(/^#{msg_invalid_email}$/)
      end

      it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 200
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_test) { create(:user, user_data) }
    let(:user_data) do
      {
        email: 'test@example.co.jp',
        password: 'password'
      }
    end

    before do
      post login_path, params: { session: user_data }
    end

    subject { proc { delete logout_path } }

    context 'ログアウトボタンを押下した場合' do
      it 'ユーザー情報が消去され、ログイン画面にリダイレクトされること' do
        expect(session[:user_id]).not_to eq nil

        subject.call
        expect(session[:user_id]).to eq nil
        expect(response).to redirect_to login_path
      end

      it_behaves_like 'レスポンス(HTTPステータスコード)が正しいこと', 302
    end
  end
end
