require 'rails_helper'
describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task, name: "最初のタスク", description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00')
  end
  context 'タスク一覧を表示する' do
    before do
      visit tasks_path
    end
    it 'タスクが表示される' do
      # 作成されたタスクが表示されている
      expect(page).to have_content '最初のタスク'
    end
  end
  context 'タスク詳細を表示する' do
    it '詳細画面に遷移する' do
      visit tasks_path
      expect(page).to have_content '最初のタスク'
    end
  end
  context 'タスク詳細を表示する' do
    before do
      visit tasks_path
    end
    it 'タスクが表示される' do
      # 作成されたタスクが表示されている
      expect(page).to have_content '最初のタスク'
      click_link '最初のタスク'
      expect(page).to have_content '最初のタスク'
      expect(page).to have_content '説明文'
      expect(page).to have_content '2021-09-01 10:00:00 +0900 〜 2021-09-02 11:00:00 +0900'
    end
  end
  context 'タスクの新規作成' do
    it 'タスクが表示される' do
      visit new_task_path
      fill_in 'タスク名', with: '作ったタスク'
      fill_in '内容', with: 'タスクの内容'
      fill_in 'start_at', with: '2021-10-01 01:02'
      fill_in 'due_date_at', with: '2021-10-02 03:04'

      click_button 'submit_btn'
      expect(page).to have_content '作ったタスク'
      expect(page).to have_content '最初のタスク'

      click_link '作ったタスク'
      expect(page).to have_content '作ったタスク'
      expect(page).to have_content 'タスクの内容'
      expect(page).to have_content '2021-10-01 01:02:00 +0900 〜 2021-10-02 03:04:00 +0900'
    end
  end

end