# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:headers) { { 'HTTP_USER_AGENT' => 'Chorme', 'REMOTE_ADDR' => '1.1.1.1' } }

  describe 'POST /login' do
    let!(:current_user) { create(:user) }
    context 'email and password is correct' do
      it 'is login success and register remember_token of cookies' do
        post login_path, params: { session: { email: 'test_user@treasuremap.com', passowrd: 'test_user' } }, headers: headers
        expect(cookies[:user_remember_token]).to eq current_user.remember_token
      end
    end

    context 'email is not correct' do
      it 'could not login,  not register remember_token of cookies' do
        post login_path, params: { session: { email: 'failed', passowrd: 'test_user' } }
        expect(cookies[:user_remember_token]).to eq nil
        expect(flash[:alert]).to eq 'Email or password is not correct'
      end
    end

    context 'password is not correct' do
      it 'could not login, not register remember_token of cookies' do
        post login_path, params: { session: { email: 'test_user@treasuremap.com', passowrd: 'failed' } }
        expect(cookies[:user_remember_token]).to eq nil
        expect(flash[:alert]).to eq 'Email or password is not correct'
      end
    end
  end

  describe 'DELETE /logout' do
    let!(:current_user) { create(:user) }
    before  { sign_in(current_user) }
    context 'logout' do
      it 'is to delete remember_token' do
        delete logout_path, headers: headers
        expect(cookies[:user_remember_token]).to eq ""
      end
    end
  end
end
