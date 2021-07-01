# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { create(:admin_user) }

  describe 'ログインページ' do
    describe '正常時' do
      it 'ログインができること' do
        visit login_path

        fill_in 'session_email', with: 'admin@example.com'
        fill_in 'session_password', with: 'AAAA1234'
        click_button 'Log in'
        expect(page).to have_content 'admin'
        expect(page).to have_content 'logout'
      end
    end

    describe '異常時' do
      it 'ログインができないこと' do
        visit login_path

        fill_in 'session_email', with: 'admin@example.com'
        fill_in 'session_password', with: 'Invalid password'
        click_button 'Log in'
        expect(page).to have_content 'Login is failed. Invalid email/password combination'
      end
    end
  end

  describe 'ログアウト' do
    describe '正常時' do
      it 'URL経由でログアウトができること' do
        visit logout_path

        visit root_path
        expect(page).to have_content 'Log in'
      end

      it 'ログアウトボタンでログアウトができること' do
        visit login_path
        fill_in 'session_email', with: 'admin@example.com'
        fill_in 'session_password', with: 'AAAA1234'
        click_button 'Log in'
        expect(page).to have_content 'admin'
        click_link 'logout'

        expect(page).to have_content 'Log in'
      end
    end
  end
end
