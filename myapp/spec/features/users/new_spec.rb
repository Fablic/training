# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/admin/user/new' do
  feature '/admin' do
    before { login(create(:user, role: 'ordinary')) }
    scenario { can_not_access_admin_page }
  end

  feature '#new' do
    before(:each) { login(user) }

    given(:user) { create(:user, role: 'admin') }

    scenario 'correctly displays user new form' do
      visit new_admin_user_path

      expect(current_path).to eq '/admin/users/new'
    end

    scenario 'renders #index' do
      visit new_admin_user_path
      click_on '一覧に戻る'

      expect(current_path).to eq '/admin/users'
      expect(page).to have_content '管理者画面ッ!!'
      expect(page).to have_content 'ユーザ一覧'
    end

    scenario 'creates new user' do
      visit new_admin_user_path

      expect(current_path).to eq '/admin/users/new'

      fill_in 'ユーザー名', with: 'aqua'
      fill_in 'Eメール', with: 'aqua@a.com'
      fill_in 'パスワード', with: 'akuaakua'

      expect { click_button '登録する' }.to change(User, :count).by(1)
      expect(User.last.name).to eq 'aqua'
      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'ユーザーが正常に作成されました'
    end

    scenario 'does NOT create without name email password' do
      visit new_admin_user_path

      expect(current_path).to eq '/admin/users/new'

      fill_in 'ユーザー名', with: ''
      fill_in 'Eメール', with: ''
      fill_in 'パスワード', with: ''

      expect { click_button '登録する' }.to change(User, :count).by(0)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content '3件のエラーが発生しました'
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'Eメールを入力してください'
      expect(page).to have_content 'パスワードを入力してください'
    end
  end
end
