# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /create' do
    subject(:login_user) { post login_path, params: { session: { email: 'aaa@example.co.jp', password: 'password' } } }

    context 'ログインに成功した時' do
      before { create(:user, email: 'aaa@example.co.jp', password: 'password') }

      it 'タスク一覧に遷移すること' do
        login_user
        expect(response).to redirect_to(tasks_path)
      end
    end

    context 'ログインに失敗した時' do
      before { create(:user, email: 'bbb@example.co.jp', password: 'wordpass') }

      it 'レスポンスが正しいこと' do
        login_user
        expect(response).to have_http_status(:ok)
      end

      it 'エラーメッセージが表示されていること' do
        login_user
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE /destory' do
    context 'ログアウトに成功した時' do
      subject(:logout_user) { delete logout_path }

      it 'ログイン画面に遷移すること' do
        logout_user
        expect(response).to redirect_to login_form_path
      end

      it 'user_idがnilになってること' do
        logout_user
        expect(session[:user_id]).to eq nil
      end
    end
  end
end
