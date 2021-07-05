# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '新規登録ページ' do
    describe '正常時' do
      it '新規登録ができること' do
        visit signup_path
        fill_in 'user_username', with: 'admin-1'
        fill_in 'user_email', with: 'admin-1@example.com'
        fill_in 'user_password', with: 'AAAA1234'
        fill_in 'user_password_confirmation', with: 'AAAA1234'
        click_button 'Create'

        expect(page).to have_content 'User registration is complete'
      end
    end

    describe '異常時' do
      let!(:user) { create(:normal_user) }
      it '新規登録ができないこと パスワード設定ミス' do
        visit signup_path
        fill_in 'user_username', with: 'admin'
        fill_in 'user_email', with: 'admin@example.com'
        fill_in 'user_password', with: 'AAAA1234'
        fill_in 'user_password_confirmation', with: 'password invalid'
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
      end

      it '新規登録ができないこと メールアドレス設定ミス' do
        visit signup_path
        fill_in 'user_username', with: 'admin'
        fill_in 'user_email', with: 'admin'
        fill_in 'user_password', with: 'AAAA1234'
        fill_in 'user_password_confirmation', with: 'AAAA1234'
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
      end

      it '新規登録ができないこと ユーザネーム重複ミス' do
        visit signup_path
        fill_in 'user_username', with: 'normal'
        fill_in 'user_email', with: 'normal-1@example.com'
        fill_in 'user_password', with: 'AAAA1234'
        fill_in 'user_password_confirmation', with: 'AAAA1234'
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
      end

      it '新規登録ができないこと メールアドレス重複ミス' do
        visit signup_path
        fill_in 'user_username', with: 'normal-1'
        fill_in 'user_email', with: 'normal@example.com'
        fill_in 'user_password', with: 'AAAA1234'
        fill_in 'user_password_confirmation', with: 'AAAA1234'
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
      end
    end
  end
end
