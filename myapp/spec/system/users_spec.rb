require 'rails_helper'

RSpec.describe 'Users System', type: :system, js: true do
  let(:user) { create(:user) }

  describe 'ログイン画面' do
    before do
      visit root_path
    end

    context '存在するユーザーでログインした時' do
      it 'タスク一覧タイトルが表示される' do
        log_in_as user
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end

    context 'メールアドレスとパスワードに誤りがありログインした時' do
      it 'ログイン画面に戻されて警告アラートが出る' do
        user.email = 'fail@example.com'
        user.password = 'failpass'
        log_in_as user
        expect(page).to have_content 'メールアドレス、もしくはパスワードに誤りがあります'
        expect(page).to have_selector('h1', text: 'ログイン')
      end
    end
  end

  describe 'ユーザー登録画面' do
    before do
      visit signup_path
    end

    context '新しいユーザーを正しく登録した時' do
      it 'ユーザー情報タイトルが表示される' do
        fill_in 'user_name', with: 'new.rakuten.taro'
        fill_in 'user_email', with: 'new-rakuten-taro@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        find('#signup-button').click
        expect(page).to have_selector('div', text: 'ようこそ、タスク管理システムへ!')
      end
    end

    context '短いパスワードで登録した時' do
      it 'ユーザー登録画面で警告が出る' do
        fill_in 'user_name', with: 'new.rakuten.taro'
        fill_in 'user_email', with: 'new-rakuten-taro@example.com'
        fill_in 'user_password', with: 'short'
        fill_in 'user_password_confirmation', with: 'short'
        find('#signup-button').click
        expect(page).to have_content 'パスワードは8文字以上で入力してください'
        expect(page).to have_selector('h1', text: 'ユーザー登録')
      end
    end

    context 'パスワードとパスワード確認用が一致させずに登録した時' do
      it 'ユーザー登録画面で警告が出る' do
        fill_in 'user_name', with: 'new.rakuten.taro'
        fill_in 'user_email', with: 'new-rakuten-taro@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'fail-password'
        find('#signup-button').click
        expect(page).to have_content 'パスワード確認用とパスワードの入力が一致しません'
        expect(page).to have_selector('h1', text: 'ユーザー登録')
      end
    end

    context '作成ずみユーザーで登録しようとした時' do
      it 'ユーザー登録画面で警告が出る' do
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        find('#signup-button').click
        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(page).to have_selector('h1', text: 'ユーザー登録')
      end
    end
  end
end
