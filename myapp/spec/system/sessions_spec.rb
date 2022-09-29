require 'rails_helper'

describe 'セッション管理機能', type: :system do
  subject(:visit_login){ visit login_path }

  describe 'ログイン機能' do
    let!(:maintenance) { FactoryBot.create(:maintenance, function_id: 1, maintenance_flag: false) }
    let!(:user_a) { FactoryBot.create(:user) }

    context 'メールアドレスとパスワードが一致する場合' do
      it 'タスク一覧画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'test@example.com'
        fill_in 'session[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_current_path root_path
      end
    end

    context 'メールアドレスとパスワードが一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end

    context 'メールアドレスが一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end

    context 'パスワードが一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'test@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end

    context 'メールアドレスが空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end

    context 'パスワードが空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'test@example.com'
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end

    context 'メールアドレスとパスワード両方が空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'メンテナンス機能' do
    context 'メンテナンス中の場合' do
      let!(:maintenance_index) { FactoryBot.create(:maintenance, function_id: 1, maintenance_flag: true) }
      let!(:maintenance_show) { FactoryBot.create(:maintenance, function_id: 2, maintenance_flag: true) }
      let!(:maintenance_new) { FactoryBot.create(:maintenance, function_id: 3, maintenance_flag: true) }
      let!(:maintenance_edit) { FactoryBot.create(:maintenance, function_id: 4, maintenance_flag: true) }

      it 'ログイン画面が表示される' do
        visit_login
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
