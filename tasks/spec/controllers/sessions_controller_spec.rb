require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#new' do
    context 'ログイン状態の場合' do
      let(:user) { create(:user) }
      before { log_in(user) }
      it '一覧ページにリダイレクトされること' do
        get :new
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end
    context 'ログアウト状態の場合' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :new
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :new
      end
    end
  end

  describe '#create' do
    let(:user) { create(:user) }
    context 'ログイン成功時' do
      it 'タスク一覧ページにリダイレクトされること' do
        post :create, params: { session: { email: user.email, password: user.password } }
        expect(response).to redirect_to root_path
      end
    end
    context 'ログイン失敗時' do
      it 'ログインページが表示され、flashメッセージが表示されること' do
        post :create, params: { session: { email: user.email, password: 'aaaa1111' } }
        expect(response).to render_template :new
        expect(flash[:danger]).to match('メールアドレスかパスワードが違います。')
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }
    before { log_in(user) }
    context 'ログアウト実行時' do
      it 'ログアウトされ、ログインページが表示されること' do
        delete :destroy
        expect(response).to redirect_to '/login'
        expect(session[:user_id]).to eq nil
      end
    end
  end
end
