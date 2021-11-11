# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'session', type: :system do
  let!(:user) { create(:generic_user) }
  let!(:admin) { create(:admin) }

  describe 'login page' do
    before do
      visit root_path
    end

    context 'with normal cases' do
      it 'login with admin' do
        expect(page).to have_content 'Task-u-ten'
        expect(page).to have_content 'メールアドレス'
        fill_in 'username', with: admin.username
        fill_in 'password', with: admin.password
        click_on 'ログイン'
        expect(page).to have_content "Hi #{admin.name}!"
        expect(page).to have_content 'Users'
      end

      it 'login with user' do
        expect(page).to have_content 'Task-u-ten'
        expect(page).to have_content 'メールアドレス'
        fill_in 'username', with: user.username
        fill_in 'password', with: user.password
        click_on 'ログイン'
        expect(page).to have_content "Hi #{user.name}!"
        expect(page).to have_no_content 'Users'
      end
    end

    context 'with error cases' do
      it 'login with admin' do
        expect(page).to have_content 'Task-u-ten'
        expect(page).to have_content 'メールアドレス'
        fill_in 'username', with: 'hohohoho'
        fill_in 'password', with: 'bad password'
        click_on 'ログイン'
        expect(page).to have_content '無効なユーザ・パスワード'
        expect(page).to have_content 'メールアドレス'
      end
    end
  end
end
