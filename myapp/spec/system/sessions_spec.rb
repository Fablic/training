require 'rails_helper'

describe 'Sessions', type: :system do

  describe '#new' do
    describe 'ログイン' do
      let(:user) { FactoryBot.create(:user, password: 'password') }
      let(:task) { FactoryBot.create(:task, user_id: user.id) }
      context 'ログイン成功' do
        it 'ログインできること' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password'
          click_on 'Login'
          expect(page).to have_current_path root_path
        end

        it 'ログイン後タスク作成画面へ遷移できること' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password'
          click_on 'Login'
          visit new_task_path
          expect(page).to have_current_path new_task_path
        end

        it 'ログイン後タスク詳細画面へ遷移できること' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password'
          click_on 'Login'
          visit task_path(task)
          expect(page).to have_current_path task_path(task)
        end

        it 'ログイン後タスク編集画面へ遷移できること' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password'
          click_on 'Login'
          visit edit_task_path(task)
          expect(page).to have_current_path edit_task_path(task)
        end
      end

      context 'ログイン失敗' do
        it 'ログインできないこと' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password_failed'
          click_on 'Login'
          expect(page).to have_current_path login_path
        end

        it 'ログイン失敗時エラーメッセージが表示されること' do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: 'password_failed'
          click_on 'Login'
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
    end
  end
end
