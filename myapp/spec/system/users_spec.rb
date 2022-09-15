# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  context 'login systems check' do
    before do
      visit admin_login_path
    end
    it 'failure login' do
      fill_in 'personal_id', with: ''
      fill_in 'password', with: ''
      click_button 'ログイン'

      expect(page).to have_content 'ログイン画面(管理者)'
      expect(page).to have_content '正しいログインIDとパスワードを入力してください'
    end

    it 'success login & logout' do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'

      expect(page).to have_content 'ユーザ管理画面'

      click_link 'ログアウト'
      expect(page).to have_content 'ログイン画面(管理者)'
    end
  end

  before do
    visit admin_login_path
  end

  let!(:user) { create(:user) }
  let!(:user2) { create(:user, name: 'MyName2', personal_id: 'MyUserID2') }

  context 'index systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'initial display (user_id asc)' do
      expect(page.text).to match(/MyName.*MyName2/)
    end
  end

  context 'create systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete new user create' do
      click_button '新規登録'
      expect(page).to have_content 'ユーザ登録画面'

      fill_in 'user[name]', with: 'newUser'
      fill_in 'user[personal_id]', with: 'newID'
      fill_in 'user[password]', with: 'new_pass'
      fill_in 'user[password_confirmation]', with: 'new_pass'
      click_button '登録する'

      expect(page).to have_content 'ユーザの登録が完了しました'
      expect(page).to have_content 'newUser'
      expect(page).to have_content 'newID'
    end

    it 'failure new user create' do
      click_button '新規登録'
      expect(page).to have_content 'ユーザ登録画面'

      fill_in 'user[name]', with: ''
      fill_in 'user[personal_id]', with: 'newID'
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: 'new_pass'
      click_button '登録する'

      expect(page).to have_content '登録に失敗しました'
      expect(page).to have_content 'ユーザ名を入力してください'
      expect(page).to have_no_content 'ユーザIDを入力してください'
      expect(page).to have_content 'パスワードを入力してください'

      click_link '一覧に戻る'
      expect(page).to have_no_content 'newID'
    end
  end

  context 'show systems check' do
    before do
      create(:task, user_id: user.id)
      create(:task, title: 'MyString2', user_id: user2.id)
      create(:task, title: 'MyString3', user_id: user2.id)
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete show task' do
      click_link('詳細', href: user_path(user))

      expect(page).to have_content 'ユーザ詳細画面'
      expect(page).to have_content 'MyName'
      expect(page).to have_content 'MyUserID'
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
      click_link '一覧に戻る'

      click_link('詳細', href: user_path(user2))

      expect(page).to have_content 'MyString2'
      expect(page).to have_content 'MyString3'
    end
  end

  context 'edit systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete edit user' do
      click_link('編集', href: edit_user_path(user))
      expect(page).to have_content 'ユーザ編集画面'

      fill_in 'user[name]', with: 'editUser'
      fill_in 'user[personal_id]', with: 'editID'
      fill_in 'user[password]', with: 'pass'
      fill_in 'user[password_confirmation]', with: 'pass'
      click_button '編集する'

      expect(page).to have_content 'ユーザの編集が完了しました'
      expect(page).to have_content 'editUser'
      expect(page).to have_content 'editID'
    end

    it 'failure edit task' do
      click_link('編集', href: edit_user_path(user))
      expect(page).to have_content 'ユーザ編集画面'

      fill_in 'user[name]', with: ''
      fill_in 'user[personal_id]', with: ''
      fill_in 'user[password]', with: 'pass'
      fill_in 'user[password_confirmation]', with: 'new_pass'
      click_button '編集する'

      expect(page).to have_content '編集に失敗しました'
      expect(page).to have_content 'ユーザ名を入力してください'
      expect(page).to have_content 'ユーザIDを入力してください'
      expect(page).to have_content 'パスワード(確認)とパスワードの入力が一致しません'

      click_link '一覧に戻る'
      expect(page).to have_content 'MyName'
      expect(page).to have_content 'MyUserID'
    end
  end

  context 'delete systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete delete task' do
      click_link('削除', href: user_path(user))
      expect do
        expect(page.accept_confirm).to eq '削除します。よろしいですか(作成したタスクも一緒に削除されます)'
        exmect(page).to have_content 'ユーザを削除しました'
        expect(page).to have_no_content 'MyName'
        expect(page).to have_no_content 'MyUserID'
      end
    end
  end
end
