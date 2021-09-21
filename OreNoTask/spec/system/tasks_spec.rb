require 'rails_helper'
describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task, name: "最初のタスク", description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00')
    FactoryBot.create(:task, name: "２番目のタスク", description: '説明文２', start_at: '2021/09/02 10:00', due_date_at: '2021/09/03 11:00')
  end

  context 'タスク一覧を表示する' do
    before do
      visit tasks_path
    end
    it '一覧画面の表示を確認する' do
      # 既存のタスクが表示されている
      expect(page).to have_content '最初のタスク'
      expect(page).to have_content '2021-09-01 10:00:00 +0900 〜 2021-09-02 11:00:00 +0900'
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021-09-02 10:00:00 +0900 〜 2021-09-03 11:00:00 +0900'
    end
  end

  context 'タスク詳細を表示する' do
    before do
      visit tasks_path
    end
    it '詳細画面に遷移し、内容を確認する' do
      click_link '最初のタスク'
      expect(page).to have_content '最初のタスク'
      expect(page).to have_content '説明文'
      expect(page).to have_content '2021-09-01 10:00:00 +0900 〜 2021-09-02 11:00:00 +0900'
    end
  end

  context 'タスクの新規作成' do
    it '新規作成画面でタスクを作成する' do
      visit new_task_path
      fill_in 'タスク名', with: '作ったタスク'
      fill_in '内容', with: 'タスクの内容'
      fill_in 'task[start_at]', with: '002021-10-01-01:02'
      fill_in 'task[due_date_at]', with: '002021-10-02-03:04'

      click_button 'commit'

      # 作成されたタスクが表示されている
      expect(page).to have_content '作ったタスク'
      expect(page).to have_content '2021-10-01 01:02:00 +0900 〜 2021-10-02 03:04:00 +0900'

      # 既存のデータに影響がない
      expect(page).to have_content '最初のタスク'
      expect(page).to have_content '2021-09-01 10:00:00 +0900 〜 2021-09-02 11:00:00 +0900'
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021-09-02 10:00:00 +0900 〜 2021-09-03 11:00:00 +0900'

      # 詳細画面で作成したタスクの内容を確認
      click_link '作ったタスク'
      expect(page).to have_content '作ったタスク'
      expect(page).to have_content 'タスクの内容'
      expect(page).to have_content '2021-10-01 01:02:00 +0900 〜 2021-10-02 03:04:00 +0900'
    end
  end

  context 'タスクの編集' do
    it 'タスクを編集する' do
      visit tasks_path
      click_link '編集', match: :first
      fill_in 'タスク名', with: '最初のタスクを編集'
      fill_in '内容', with: 'タスクの内容を編集'
      fill_in 'task[start_at]', with: '002021-10-11-11:12'
      fill_in 'task[due_date_at]', with: '002021-10-12-13:14'

      click_button 'commit'
      # 編集されたタスクが表示されている
      expect(page).to have_content '最初のタスクを編集'
      expect(page).to have_content '2021-10-11 11:12:00 +0900 〜 2021-10-12 13:14:00 +0900'

      # 既存のデータに影響がない
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021-09-02 10:00:00 +0900 〜 2021-09-03 11:00:00 +0900'


      # 詳細画面で編集したタスクの内容を確認
      click_link '最初のタスクを編集'
      expect(page).to have_content '最初のタスクを編集'
      expect(page).to have_content 'タスクの内容を編集'
      expect(page).to have_content '2021-10-11 11:12:00 +0900 〜 2021-10-12 13:14:00 +0900'
    end
  end

  context 'タスクの削除' do
    it 'タスクを削除する' do
      visit tasks_path
      click_button '削除', match: :first

      # 作成されたタスクが表示されてない
      expect(page).to_not have_content '最初のタスク'
      expect(page).to_not have_content '2021-09-01 10:00:00 +0900 〜 2021-09-02 11:00:00 +0900'

      # 既存のデータに影響がない
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021-09-02 10:00:00 +0900 〜 2021-09-03 11:00:00 +0900'
    end
  end

end