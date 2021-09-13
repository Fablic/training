require 'rails_helper'

RSpec.describe 'ログイン', js: true, type: :system do
  let!(:test_user) { create(:user) }
  let!(:task_list) { create_list(:task, 10) }

  describe 'ログイン前' do
    before { visit login_path }
    subject { page }
    it 'ログイン画面へ遷移する' do
      visit root_path
      is_expected.to have_current_path login_path
    end
    context '入力エラーなし' do
      it 'ログインできる' do
        fill_in 'Name', with: test_user.name
        fill_in 'Password', with: test_user.password
        click_button 'ログイン'
        is_expected.to have_current_path root_path
      end
    end
    context 'Nameが未入力' do
      it 'エラーが表示される' do
        fill_in 'Name', with: ''
        fill_in 'Password', with: test_user.password
        click_button 'ログイン'
        is_expected.to have_content 'Name,Passwordが一致しません'
        is_expected.to have_current_path login_path
      end
    end
    context 'Passwordが未入力' do
      it 'エラーが表示される' do
        fill_in 'Name', with: test_user.name
        fill_in 'Password', with: ''
        click_button 'ログイン'
        is_expected.to have_content 'Name,Passwordが一致しません'
        is_expected.to have_current_path login_path
      end
    end
    context 'Passwordが異なる' do
      it 'エラーが表示される' do
        fill_in 'Name', with: test_user.name
        fill_in 'Password', with: 'error_password'
        click_button 'ログイン'
        is_expected.to have_content 'Name,Passwordが一致しません'
        is_expected.to have_current_path login_path
      end
    end
  end

  describe 'ログイン後' do
    before do
      visit login_path
      fill_in 'Name', with: test_user.name
      fill_in 'Password', with: test_user.password
      click_button 'ログイン'
    end
    subject { page }

    it 'Top(タスク一覧)ページが表示される' do
      visit root_path
      is_expected.to have_current_path root_path
    end
    it 'ログアウトでログイン画面へ遷移する' do
      click_link 'ログアウト'
      is_expected.to have_current_path login_path
    end
  end

  describe '異なるユーザの操作' do
    let!(:test_other_user) { create(:user, name: 'test_other_name') }
    let!(:task_other) { create(:task, user_id: test_other_user.id, title: 'test_other_title') }

    before do
      visit login_path
      fill_in 'Name', with: test_user.name
      fill_in 'Password', with: test_user.password
      click_button 'ログイン'
    end
    subject { page }

    it '他のユーザのタスクが表示されないこと' do
      is_expected.not_to have_content(task_other.title)
    end
    it '他のユーザのタスクを編集できないこと' do
      visit edit_task_path(task_other.id)
      is_expected.to have_content 'ページが見つかりません'
    end
  end
end
