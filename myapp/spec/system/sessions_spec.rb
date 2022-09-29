require 'rails_helper'

describe 'セッション管理機能', type: :system do
  subject(:visit_login){ visit login_path }

  describe 'ログイン機能' do
    let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 101, name: 'タスク一覧', maintenance_flg: false) }
    let!(:user_a) { FactoryBot.create(:user) }

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
        expect(page).to have_content 'ログイン画面'
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
        expect(page).to have_content 'ログイン画面'
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
        expect(page).to have_content 'ログイン画面'
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
        expect(page).to have_content 'ログイン画面'
      end
    end

    context 'パスワードが空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'ログイン画面'
      end
    end

    context 'メールアドレスとパスワード両方が空の場合' do
      it 'ログイン画面が表示される' do
        visit_login
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'ログイン画面'
      end
    end
  end

  describe 'メンテナンス機能' do
    context 'メンテナンス中の場合' do
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 101, name: 'タスク一覧', maintenance_flg: true) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 102, name: 'タスク詳細', maintenance_flg: true) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 103, name: 'タスク作成', maintenance_flg: true) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 104, name: 'タスク編集', maintenance_flg: true) }

      it 'ログイン画面が表示される' do
        visit_login
        expect(page).to have_content 'ログイン画面'
      end
    end

    context 'メンテナンス中でない場合' do
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 101, name: 'タスク一覧', maintenance_flg: false) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 102, name: 'タスク詳細', maintenance_flg: false) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 103, name: 'タスク作成', maintenance_flg: false) }
      let!(:maintenance) { FactoryBot.create(:maintenance, content_id: 104, name: 'タスク編集', maintenance_flg: false) }

      it 'ログイン画面が表示される' do
        visit_login
        expect(page).to have_content 'ログイン画面'
      end
    end
  end
end
