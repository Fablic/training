# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/admin/user/:id/edit' do
  feature '#edit' do
    before(:each) { login(user) }

    given(:user) { create(:user, role: 'admin') }

    scenario 'renders #index' do
      visit edit_admin_user_path(user)
      click_on '一覧に戻る'

      expect(current_path).to eq admin_users_path
      expect(page).to have_content '管理者画面ッ!!'
    end

    scenario 'correctly updates edit user' do
      visit edit_admin_user_path(user)

      expect(current_path).to eq "/admin/users/#{user.id}/edit"

      fill_in 'ユーザー名', with: 'うぷだてユーザー名'
      fill_in 'Eメール', with: 'updateEmail@email.com'

      expect { click_button '更新する' }.to \
        change { User.exists?(name: 'うぷだてユーザー名', email: 'updateEmail@email.com') }.from(false).to(true)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'ユーザーが正常に更新されました'
    end

    scenario 'does NOT update with empty name, email' do
      visit edit_admin_user_path(user)

      expect(current_path).to eq "/admin/users/#{user.id}/edit"

      fill_in 'ユーザー名', with: ''
      fill_in 'Eメール', with: ''

      expect { click_button '更新する' }.to change(User, :count).by(0)
      expect(current_path).to eq "/admin/users/#{User.last.id}"
      expect(page).to have_content '2件のエラーが発生しました'
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'Eメールを入力してください'
    end
  end
end
