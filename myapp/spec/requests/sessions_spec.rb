# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    let!(:user) do
      User.create(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    context 'with valid credentials' do
      it 'logs in the user and redirects to the root path' do
        post login_path, params: { session: { email: user.email, password: 'password' } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('ログイン成功！')
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user and re-renders the login page' do
        post login_path, params: { session: { email: user.email, password: 'wrongpassword' } }
        expect(response).to render_template(:new)
        expect(response.body).to include('ログイン失败。')
      end
    end

    context 'with non-existent user' do
      it 'does not log in the user and re-renders the login page' do
        post login_path, params: { session: { email: 'nonexistent@example.com', password: 'password' } }
        expect(response).to render_template(:new)
        expect(response.body).to include('ログイン失败。')
      end
    end
  end

  describe 'GET /logout' do
    let!(:user) do
      User.create(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    before do
      post login_path, params: { session: { email: user.email, password: 'password' } }
    end

    it 'logs out the user and redirects to the root path' do
      get logout_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include('ログアウトしました。')
    end
  end
end
