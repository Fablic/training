# frozen_string_literal: true

require 'rails_helper'
describe 'タスク管理機能', type: :system do
  before do
    create(:task, name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', created_at: '2021/07/01 09:00:04')
    create(:task, name: '２番目のタスク', description: '説明文２', start_at: '2021/08/02 10:00', due_date_at: '2021/08/03 11:00', created_at: '2021/07/01 09:00:03')
    create(:task, name: '追加したタスク', description: '追加した説明文', start_at: '2021/10/01 10:00', due_date_at: '2021/10/03 11:00', created_at: '2021/07/01 09:00:02')
    create(:task, name: '最後のタスク', description: '最後の説明文', start_at: '2021/12/02 10:00', due_date_at: '2021/12/03 11:00', created_at: '2021/07/01 09:00:01')
  end

  context 'タスク一覧を表示する' do
    it '一覧画面の表示を確認する' do
      visit tasks_path

      # 既存のタスクが順番通り表示されている
      expect(find('li:nth-child(1)')).to have_content '最初のタスク'
      expect(find('li:nth-child(1)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
      expect(find('li:nth-child(2)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
      expect(find('li:nth-child(3)')).to have_content '追加したタスク'
      expect(find('li:nth-child(3)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
      expect(find('li:nth-child(4)')).to have_content '最後のタスク'
      expect(find('li:nth-child(4)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'
    end

    it '並び替えの確認' do
      visit tasks_path

      click_link '降順'
      expect(find('li:nth-child(1)')).to have_content '最後のタスク'
      expect(find('li:nth-child(2)')).to have_content '追加したタスク'
      expect(find('li:nth-child(3)')).to have_content '最初のタスク'
      expect(find('li:nth-child(4)')).to have_content '２番目のタスク'

      click_link '昇順'
      expect(find('li:nth-child(1)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(2)')).to have_content '最初のタスク'
      expect(find('li:nth-child(3)')).to have_content '追加したタスク'
      expect(find('li:nth-child(4)')).to have_content '最後のタスク'

      click_link 'クリア'
      expect(find('li:nth-child(1)')).to have_content '最初のタスク'
      expect(find('li:nth-child(2)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(3)')).to have_content '追加したタスク'
      expect(find('li:nth-child(4)')).to have_content '最後のタスク'
    end
  end

  context 'タスク詳細を表示する' do
    it '詳細画面に遷移し、内容を確認する' do
      visit tasks_path

      click_link '最初のタスク'
      expect(page).to have_content '最初のタスク'
      expect(page).to have_content '説明文'
      expect(page).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
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
      expect(find('li:nth-child(1)')).to have_content '作ったタスク'
      expect(find('li:nth-child(1)')).to have_content '2021年10月01日(金) 01:02 〜 2021年10月02日(土) 03:04'

      # 既存のデータに影響がない
      expect(find('li:nth-child(2)')).to have_content '最初のタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
      expect(find('li:nth-child(3)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(3)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
      expect(find('li:nth-child(4)')).to have_content '追加したタスク'
      expect(find('li:nth-child(4)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
      expect(find('li:nth-child(5)')).to have_content '最後のタスク'
      expect(find('li:nth-child(5)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'

      # 詳細画面で作成したタスクの内容を確認
      click_link '作ったタスク'
      expect(page).to have_content '作ったタスク'
      expect(page).to have_content 'タスクの内容'
      expect(page).to have_content '2021年10月01日(金) 01:02 〜 2021年10月02日(土) 03:04'
    end
  end

  context 'タスクの編集' do
    it 'タスクを編集する' do
      visit tasks_path
      find('li:nth-child(1)').click_link('編集')
      fill_in 'タスク名', with: '最初のタスクを編集'
      fill_in '内容', with: 'タスクの内容を編集'
      fill_in 'task[start_at]', with: '002021-10-11-11:12'
      fill_in 'task[due_date_at]', with: '002021-10-12-13:14'

      click_button 'commit'
      # 編集されたタスクが表示されている
      expect(find('li:nth-child(1)')).to have_content '最初のタスクを編集'
      expect(find('li:nth-child(1)')).to have_content '2021年10月11日(月) 11:12 〜 2021年10月12日(火) 13:14'

      # 既存のデータに影響がない
      expect(find('li:nth-child(2)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
      expect(find('li:nth-child(3)')).to have_content '追加したタスク'
      expect(find('li:nth-child(3)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
      expect(find('li:nth-child(4)')).to have_content '最後のタスク'
      expect(find('li:nth-child(4)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'

      # 詳細画面で編集したタスクの内容を確認
      click_link '最初のタスクを編集'
      expect(page).to have_content '最初のタスクを編集'
      expect(page).to have_content 'タスクの内容を編集'
      expect(page).to have_content '2021年10月11日(月) 11:12 〜 2021年10月12日(火) 13:14'
    end
  end

  context 'タスクの削除' do
    it 'タスクを削除する' do
      visit tasks_path
      find('li:nth-child(1)').click_button('削除')

      # 作成されたタスクが表示されてない
      expect(page).not_to have_content '最初のタスク'
      expect(page).not_to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'

      # 既存のデータに影響がない
      expect(find('li:nth-child(1)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(1)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
      expect(find('li:nth-child(2)')).to have_content '追加したタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
      expect(find('li:nth-child(3)')).to have_content '最後のタスク'
      expect(find('li:nth-child(3)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'
    end
  end
end
