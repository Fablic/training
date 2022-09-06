require 'rails_helper'

describe 'セッション管理機能', type: :system do
  describe 'ログイン機能' do
    let!(:user_a) { FactoryBot.create(:user) }
    subject(:visit_login){ visit login_path }

    context 'メールアドレスとパスワードを入力した場合' do
      it 'タスク一覧画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_current_path root_path
      end
      it 'タスク一覧画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_selector '.alert-success', text: 'ログインしました。'
      end
    end

    context 'メールアドレスもパスワードも一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end

    context 'メールアドレスが一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: 'aaa@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end

    context 'パスワードが一致しない場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'aaa'
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end

    context 'メールアドレスが空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end

    context 'パスワードが空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end

    context 'メールアドレスとパスワード両方が空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_current_path login_path
      end
      it 'Flashメッセージが表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_selector '.alert-failed', text: 'ログインに失敗しました。'
      end
    end
  end
end
