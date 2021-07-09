# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Users', type: :system do
  describe '一覧画面', :require_login do
    let!(:user2) { create(:admin_user, username: 'admin2', email: 'admin2@example.com') }
    let!(:task) { create(:task, user_id: user.id) }

    context '正常時' do
      before { visit admin_users_path }

      it 'ユーザが表示されている' do
        expect(page).to have_content 'admin'
        expect(page).to have_content 'admin@example.com'
        expect(page).to have_content 'admin2'
        expect(page).to have_content 'admin2@example.com'
      end

      it 'ユーザの保持するタスク数が正しい' do
        expect(all("[data-testid='user-has-task']")[0].text).to match '0'
        expect(all("[data-testid='user-has-task']")[1].text).to match '1'
      end
    end

    context '削除ボタンを押したとき' do
      before { visit admin_users_path }

      it 'ユーザの削除ができる' do
        click_link 'Delete', match: :first

        expect(page).to have_content 'admin'
        expect(page).to have_content 'admin@example.com'
        expect(page).to_not have_content 'admin2'
        expect(page).to_not have_content 'admin2@example.com'
      end
    end
  end

  describe '詳細画面', :require_login do
    let!(:user2) { create(:admin_user, username: 'admin2', email: 'admin2@example.com') }
    let!(:task) { create(:task, user_id: user2.id) }

    context '正常時' do
      before { visit admin_user_path(user2) }

      it 'ユーザが表示されている' do
        expect(page).to have_content 'admin2'
        expect(page).to have_content 'admin2@example.com'
      end

      it 'ユーザのタスクが1つ表示されている' do
        expect(page).to have_content 'タイトル'
        expect(all("[data-testid='task-card']").length).to match 1
      end
    end
  end

  describe '編集画面', :require_login do
    let!(:user2) { create(:admin_user, username: 'admin2', email: 'admin2@example.com') }
    let!(:task) { create(:task, user_id: user2.id) }

    context '正常時' do
      it 'ユーザを編集できる' do
        visit edit_admin_user_path(user2)
        fill_in 'user_username', with: 'admin2-edit'
        fill_in 'user_email', with: 'admin2-edit@example.com'
        fill_in 'user_password', with: 'AAAA12345678'
        fill_in 'user_password_confirmation', with: 'AAAA12345678'
        select 'normal', from: 'user_role'
        click_button 'Edit'

        expect(page).to have_content 'admin2-edit'
        expect(page).to have_content 'admin2-edit@example.com'
        expect(page).to have_content 'normal'
      end
    end

    context '異常時' do
      it 'パスワード不整合' do
        visit edit_admin_user_path(user2)
        fill_in 'user_username', with: 'admin2-edit'
        fill_in 'user_email', with: 'admin2-edit@example.com'
        fill_in 'user_password', with: 'AAAA12345678'
        fill_in 'user_password_confirmation', with: ''
        select 'normal', from: 'user_role'
        click_button 'Edit'

        expect(page).to have_content "Password confirmation doesn't match Password"
      end

      it 'username duplicate' do
        visit edit_admin_user_path(user2)
        fill_in 'user_username', with: 'admin'
        fill_in 'user_email', with: 'admin2-edit@example.com'
        fill_in 'user_password', with: 'AAAA12345678'
        fill_in 'user_password_confirmation', with: 'AAAA12345678'
        select 'normal', from: 'user_role'
        click_button 'Edit'

        expect(page).to have_content 'Username has already been taken'
      end

      it 'email duplicate' do
        visit edit_admin_user_path(user2)
        fill_in 'user_username', with: 'admin-2'
        fill_in 'user_email', with: 'admin@example.com'
        fill_in 'user_password', with: 'AAAA12345678'
        fill_in 'user_password_confirmation', with: 'AAAA12345678'
        select 'normal', from: 'user_role'
        click_button 'Edit'

        expect(page).to have_content 'Email has already been taken'
      end
    end
  end

  describe '新規作成画面', :require_login do
    context '正常時' do
      it 'ユーザ登録ができる' do
        visit new_admin_user_path
        fill_in 'user_username', with: 'admin-3'
        fill_in 'user_email', with: 'admin-3@example.com'
        fill_in 'user_password', with: 'AAAA12345678'
        fill_in 'user_password_confirmation', with: 'AAAA12345678'
        select 'normal', from: 'user_role'
        click_button 'Create'

        expect(page).to have_content 'admin-3'
        expect(page).to have_content 'admin-3@example.com'
      end
    end

    context '異常時' do
      it 'ユーザ登録が失敗する' do
        visit new_admin_user_path
        fill_in 'user_username', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''
        click_button 'Create'

        expect(page).to have_content "Username can't be blank"
      end
    end
  end
end
