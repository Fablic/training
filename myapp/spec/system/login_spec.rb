require 'rails_helper'

RSpec.describe 'ログイン機能', type: :system do
  let!(:user) { create(:user, name: 'MM', email: 'test@test.com', password: 'password') }

  describe '画面表示' do
    before do
      visit root_path
    end

    context 'ログインせずに他のページへアクセスしたとき' do
      it 'ログイン画面が表示されること' do
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector('.alert-danger', text: I18n.t('session.need_login'))
        expect(page).to have_field 'session[email]'
        expect(page).to have_field 'session[password]'
        expect(page).to have_button 'ログイン'
        expect(page).to have_link 'サインイン'
      end
    end
  end

  describe 'ログイン処理' do
    before do
      visit login_path
      fill_in 'session[email]', with: login_email
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end

    context '正しい情報を入力したとき' do
      let(:login_email) { 'test@test.com' }

      it 'ログインできる' do
        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('session.login.success'))
      end
    end

    context '誤った情報を入力したとき' do
      let(:login_email) { 'test@hoge.com' }

      it 'ログインできない' do
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector('.alert-danger', text: I18n.t('session.login.failure'))
      end
    end
  end

  describe 'ログアウト処理' do
    before do
      visit login_path
      fill_in 'session[email]', with: 'test@test.com'
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end

    context 'ログアウトを選択したとき' do
      before do
        click_link 'ログアウト'
      end

      it 'ログアウトできる' do
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('session.logout.success'))
      end
    end
  end
end
