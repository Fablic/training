# frozen_string_literal: true

require 'rails_helper'
describe 'タスク管理機能', type: :system do
  let!(:task_a) {create(:task, name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00')}
  let!(:task_b) {create(:task, name: '２番目のタスク', description: '説明文２', start_at: '2021/09/02 10:00', due_date_at: '2021/09/03 11:00')}

  describe '呼び出しレコードの順番をチェックする' do
    let!(:task_c) {create(:task, name: '追加したタスク', description: '追加した説明文', start_at: '2021/08/01 10:00', due_date_at: '2021/08/03 11:00')}
    let!(:task_d) {create(:task, name: '最後のタスク', description: '最後の説明文', start_at: '2021/07/02 10:00', due_date_at: '2021/07/03 11:00')}

    it 'ランダムな情報を入力したレコードで順番を確認' do
      Task.order('created_at desc').all.should == [task_d, task_c, task_b, task_a]
    end
  end

  context 'タスク一覧を表示する' do
    it '一覧画面の表示を確認する' do
      visit tasks_path

      # 既存のタスクが順番通り表示されている
      expect(find('li:nth-child(1)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(1)')).to have_content '2021年09月02日(木) 10:00 〜 2021年09月03日(金) 11:00'
      expect(find('li:nth-child(2)')).to have_content '最初のタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
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
      expect(find('li:nth-child(2)')).to have_content '２番目のタスク'
      expect(find('li:nth-child(2)')).to have_content '2021年09月02日(木) 10:00 〜 2021年09月03日(金) 11:00'
      expect(find('li:nth-child(3)')).to have_content '最初のタスク'
      expect(find('li:nth-child(3)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'

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
      find('li:nth-child(2)').click_link('編集')
      fill_in 'タスク名', with: '最初のタスクを編集'
      fill_in '内容', with: 'タスクの内容を編集'
      fill_in 'task[start_at]', with: '002021-10-11-11:12'
      fill_in 'task[due_date_at]', with: '002021-10-12-13:14'

      click_button 'commit'
      # 編集されたタスクが表示されている
      expect(page).to have_content '最初のタスクを編集'
      expect(page).to have_content '2021年10月11日(月) 11:12 〜 2021年10月12日(火) 13:14'

      # 既存のデータに影響がない
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021年09月02日(木) 10:00 〜 2021年09月03日(金) 11:00'

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
      find('li:nth-child(2)').click_button('削除')

      # 作成されたタスクが表示されてない
      expect(page).not_to have_content '最初のタスク'
      expect(page).not_to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'

      # 既存のデータに影響がない
      expect(page).to have_content '２番目のタスク'
      expect(page).to have_content '2021年09月02日(木) 10:00 〜 2021年09月03日(金) 11:00'
    end
  end
end
