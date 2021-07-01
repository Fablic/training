require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET new' do
    it 'リクエストが成功すること' do
      get login_url
      expect(response.status).to eq(200)
    end

    it 'Task Registration Pageが表示されること' do
      get login_url
      expect(response.body).to include 'Login Page'
    end
  end

  describe 'POST create' do
    let(:user) { FactoryBot.create :user }

    context 'ログインが成功する場合' do
      it 'リクエストが成功すること' do
        post login_url, params: { email: user.email, password: user.password }
        expect(response.status).to eq(302)
      end

      it 'セッションの中にuser_idを保存していること' do
        post login_url, params: { email: user.email, password: user.password }
        expect(session[:user_id]).to eq(user.id)
      end

      it 'タスク一覧画面にリダイレクトされること' do
        post login_url, params: { email: user.email, password: user.password }
        expect(response).to redirect_to tasks_path
      end
    end

    context 'ログインに失敗する場合' do
      it 'リクエストが成功すること' do
        post login_url, params: { email: user.email, password: 'aaaaaaaaaaaaa' }
        expect(response.status).to eq(200)
      end

      it 'フラッシュメッセージが表示されること' do
        post login_url, params: { email: user.email, password: 'aaaaaaaaaaaaa' }
        expect(flash[:danger]).to be_truthy
      end
    end
  end

  describe 'DELETE destroy' do
    context 'ログアウトが成功する場合' do
      let(:user) { FactoryBot.create :user }
      before { log_in_as user }

      it 'リクエストが成功すること' do
        delete logout_url
        expect(response.status).to eq(302)
      end

      it 'セッションの中にuser_idを保存していない' do
        delete logout_url
        expect(session[:user_id]).to be nil
      end

      it 'ログイン画面にリダイレクトされること' do
        delete logout_url
        expect(response).to redirect_to login_path
      end
    end
  end
end
