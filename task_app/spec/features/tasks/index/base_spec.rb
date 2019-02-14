# frozen_string_literal: true

require 'rails_helper'

feature '画面表示機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }
  let!(:user1_task) { FactoryBot.create(:task, name: 'user1のタスク', user: user1) }

  context 'ログインせず画面へアクセスしたとき' do
    before { visit root_path }

    scenario 'メッセージと共にログイン画面が表示される' do
      expect(current_path).to eq login_path
      expect(page).to have_selector('.alert-danger', text: 'サービスを利用するにはログインが必要です')
      expect(page).to have_selector('form', count: 1)
    end
  end

  context 'user1でログインした状態でアクセスしたとき' do
    before { login(user1) }

    scenario 'タスク一覧画面が表示され、user1のタスクが確認できる' do
      tr = page.all('tbody tr')

      expect(current_path).to eq root_path
      expect(tr.size).to eq 1
      expect(tr[0].text).to have_content user1_task.name
    end
  end

  context 'user2でログインした状態でアクセスしたとき' do
    before { login(user2) }

    scenario 'タスク一覧画面が表示されるが、user1のタスクは確認できない' do
      expect(current_path).to eq root_path
      expect(page.all('tbody tr').size).to eq 0
    end
  end
end

feature 'タスク削除機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }

  before do
    login(user)
    click_on('削除')
  end

  context '確認ダイアログでOKを押したとき' do
    scenario 'タスクは削除され、タスク一覧画面にメッセージが表示される' do
      page.accept_confirm
      expect(page).to have_selector '.alert-success', text: 'タスク「掃除」を削除しました。'
      expect(page.all('tbody tr').size).to eq 0
      expect(Task.count).to eq 0
    end
  end

  context '確認ダイアログでキャンセルを押したとき' do
    scenario 'タスクは削除されず、そのままタスク一覧画面が表示される' do
      page.dismiss_confirm
      expect(page).to have_no_selector '.alert-success', text: 'タスク「掃除」を削除しました。'
      expect(page.all('tbody tr').size).to eq 1
      expect(Task.count).to eq 1
    end
  end
end
