require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) {
    FactoryBot.create(:user)
  }

  describe 'ログイン画面', type: :system do
    context '正しいemailとpasswordの組み合わせのとき' do
      example 'タスク一覧画面に遷移' do
        login(user)
        expect(page).to have_content I18n.t('tasks.index.all')
      end
    end

    context '誤ったemailのとき' do
      example 'ログイン画面にリダイレクト' do
        visit login_path
        fill_in 'Email', with: 'invalid@example.com'
        fill_in 'Password', with: user.password
        click_button 'Login'
        expect(page).to have_content I18n.t('sessions.create.invalid')
      end
    end

    context '誤ったpasswordのとき' do
      example 'ログイン画面にリダイレクト' do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'invalid'
        click_button 'Login'
        expect(page).to have_content I18n.t('sessions.create.invalid')
      end
    end
  end

  describe 'ログアウト', type: :system do
    context 'ログアウトリンクを押下したとき' do
      example 'ログイン画面にリダイレクト' do
        login(user)
        click_link 'Logout'
        expect(page).to have_content 'Login'
      end
    end
  end

  describe 'タスクの一覧', type: :system do
    context '2人のユーザーがタスクを作成した時' do
      example '自分のタスクのみが表示' do
        another_user = FactoryBot.create(:user, email: 'anothor@example.com')
        task1 = FactoryBot.create(:task, title: 'title1', user_id: user.id)
        task2 = FactoryBot.create(:task, title: 'title2', user_id: another_user.id)
        login(user)
        expect(page).to have_content 'title1'
        expect(page).not_to have_content 'title2'
      end
    end
  end
end
