# frozen_string_literal: true

require 'rails_helper'
require 'rake_helper'

RSpec.describe 'TaskSchedule', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, title: 'showタスク', body: 'showボディ', finish_at: 1.year.from_now, user_id: user.id) }
  let(:label) { create(:label, :labels1) }
  let!(:labelling) { create(:labelling, task_id: task.id, label_id: label.id) }
  File.delete('tmp/maintenance.txt') if File.exist?('tmp/maintenance.txt')

  context 'login systems check' do
    before do
      visit login_path
    end

    it 'failure login' do
      fill_in 'personal_id', with: ''
      fill_in 'password', with: ''
      click_button 'ログイン'

      expect(page).to have_content 'ログイン画面'
      expect(page).to have_content '正しいログインIDとパスワードを入力してください'
    end

    it 'success login & logout' do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'

      expect(page).to have_content 'タスク一覧画面'
      click_link 'ログアウト'

      expect(page).to have_content 'ログイン画面'
    end
  end

  before do
    visit login_path
  end

  context 'order systems check' do
    before do
      create(:task, title: 'secondタスク', body: 'secondボディ', created_at: 1.day.from_now, finish_at: 1.day.from_now, user_id: user.id)
      create(:task, title: 'thirdタスク', body: 'thirdボディ', created_at: 1.day.ago, finish_at: 1.week.from_now, user_id: user.id)
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'initial display (finish_at asc)' do
      expect(page).to have_content 'タスク一覧画面'
      expect(page.text).to match(/secondタスク.*thirdタスク.*showタスク/)
    end

    it 'complete order created_at' do
      click_link('▼', href: /\?asc=true/)
      expect(page.text).to match(/thirdボディ.*showボディ.*secondボディ/)
      click_link('▲', href: /\?desc=true/)
      expect(page.text).to match(/secondボディ.*showボディ.*thirdボディ/)
    end

    it 'complete order finish_at' do
      click_link('▼', href: /finish_asc=true/)
      expect(page.text).to match(/secondタスク.*thirdタスク.*showタスク/)
      click_link('▲', href: /finish_desc=true/)
      expect(page.text).to match(/showボディ.*thirdボディ.*secondボディ/)
    end
  end

  context 'create systems check' do
    before do
      create(:label, :labels2)
      create(:user, personal_id: 'create', name: 'user 太郎')
      fill_in 'personal_id', with: 'create'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete new task create' do
      click_button 'タスク登録'

      expect(page).to have_content 'タスク登録画面'
      fill_in 'task[title]', with: 'newタスク'
      fill_in 'task[body]', with: 'newボディ'
      fill_in 'task[finish_at]', with: '9999-01-01'
      select 'user 太郎', from: 'task[user_id]'
      check 'task_label_ids_1'
      check 'task_label_ids_2'
      click_button '登録する'

      expect(page).to have_content 'タスクの登録が完了しました'
      expect(page).to have_content 'newタスク'
      expect(page).to have_content 'newボディ'
      expect(page).to have_content '9999/01/01'
      expect(page).to have_content '未着手'
      expect(page).to have_content 'user 太郎'
      expect(page).to have_content 'MyLabelName1'
      expect(page).to have_content 'MyLabelName2'
    end

    it 'failure new task create' do
      visit task_schedule_index_path
      click_button 'タスク登録'

      expect(page).to have_content 'タスク登録画面'
      fill_in 'task[title]', with: ''
      fill_in 'task[body]', with: 'newボディ'
      click_button '登録する'
      expect(page).to have_content '登録に失敗しました'
      expect(page).to have_content 'タスク名を入力してください'
      expect(page).to have_no_content 'タスク本文を入力してください'
      expect(page).to have_content '終了期限を入力してください'
      expect(page).to have_content '作成者を入力してください'
      click_link '一覧に戻る'

      expect(page).to have_no_content 'newボディ'
    end
  end

  context 'show systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete show task' do
      click_link('詳細', href: task_schedule_path(task))
      expect(page).to have_content 'タスク詳細画面'
      expect(page).to have_content 'showタスク'
      expect(page).to have_content 'showボディ'
      expect(page).to have_content 'MyName'
      select '着手中', from: 'task[status]'
      expect(page).to have_content '着手中'
    end
  end

  context 'edit systems check' do
    before do
      create(:user, name: 'user 二郎', personal_id: 'editID')
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete edit task' do
      click_link('編集', href: edit_task_schedule_path(task))

      expect(page).to have_content 'タスク編集画面'
      fill_in 'task[title]', with: 'editタスク'
      fill_in 'task[body]', with: 'editボディ'
      fill_in 'task[finish_at]', with: '2112-09-03'
      click_button '編集する'

      expect(page).to have_content 'タスクの編集が完了しました'
      expect(page).to have_no_content 'MyString'
      expect(page).to have_no_content 'MyText'
      expect(page).to have_content 'editタスク'
      expect(page).to have_content 'editボディ'
      expect(page).to have_content '2112/09/03'
    end

    it 'failure edit task' do
      click_link('編集', href: edit_task_schedule_path(task))
      expect(page).to have_content 'タスク編集画面'

      fill_in 'task[title]', with: ''
      fill_in 'task[body]', with: ''
      fill_in 'task[finish_at]', with: ''
      click_button '編集する'
      expect(page).to have_content '編集に失敗しました'
      expect(page).to have_content 'タスク名を入力してください'
      expect(page).to have_content 'タスク本文を入力してください'
      expect(page).to have_content '終了期限を入力してください'
      click_link '一覧に戻る'

      expect(page).to have_content 'showタスク'
      expect(page).to have_content 'showボディ'
    end

    it 'create user change edit task' do
      click_link('編集', href: edit_task_schedule_path(task))
      expect(page).to have_content 'タスク編集画面'

      fill_in 'task[title]', with: 'editタスク'
      fill_in 'task[body]', with: 'editボディ'
      fill_in 'task[finish_at]', with: '2112-09-03'
      select 'user 二郎', from: 'task[user_id]'
      click_button '編集する'

      expect(page).to have_content 'タスクの編集が完了しました'
      expect(page).to have_no_content 'showタスク'
      expect(page).to have_no_content 'showボディ'
      expect(page).to have_no_content 'editタスク'
      expect(page).to have_no_content 'editボディ'
      expect(page).to have_no_content 'user 二郎'
    end
  end

  context 'delete systems check' do
    before do
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete delete task' do
      click_link('削除', href: task_schedule_path(task))
      expect do
        expect(page.accept_confirm).to eq '削除します。よろしいですか'
        exmect(page).to have_content 'タスクを削除しました'
        expect(page).to have_no_content 'showタスク'
        expect(page).to have_no_content 'showボディ'
      end
    end
  end

  context 'search systems check' do
    let(:label2) { create(:label, :labels2) }
    let(:task2) { create(:task, title: 'thirdタスク', status: 2, user_id: user.id) }
    before do
      create(:labelling, task_id: task2.id, label_id: label2.id)
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete title search' do
      fill_in 'search[title]', with: 'how'
      click_button '検索'
      expect(page).to have_content 'showタスク'
      expect(page).to have_no_content 'thirdタスク'
    end

    it 'complete status search' do
      select '完了', from: 'search[status]'
      click_button '検索'
      expect(page).to have_no_content 'showタスク'
      expect(page).to have_content 'thirdタスク'
    end

    it 'complete labels search' do
      check 'search_label_ids_1'
      click_button '検索'
      expect(page).to have_content 'showタスク'
      expect(page).to have_no_content 'thirdタスク'
    end
  end

  context 'paginate systems check' do
    before do
      create(:task, finish_at: 1.day.from_now, user_id: user.id)
      create(:task, finish_at: 1.week.from_now, user_id: user.id)
      create(:task, finish_at: 2.years.from_now, user_id: user.id)
      create(:task, title: 'タスク5', finish_at: 3.years.from_now, user_id: user.id)
      create(:task, title: 'タスク6', finish_at: 4.years.from_now, user_id: user.id)
      fill_in 'personal_id', with: 'MyUserID'
      fill_in 'password', with: 'pass'
      click_button 'ログイン'
    end

    it 'complete paginate' do
      expect(page).to have_content 'タスク5'
      expect(page).to have_no_content 'タスク6'
      click_link '次'
      expect(page).to have_content 'タスク6'
      expect(page).to have_no_content 'タスク5'
    end
  end

  context 'maintenance_mode_check' do
    before do
      File.new('tmp/maintenance.txt', 'w') unless File.exist?('tmp/maintenance.txt')
    end

    after do
      File.delete('tmp/maintenance.txt') if File.exist?('tmp/maintenance.txt')
    end

    it 'task_maintenance:start' do
      visit login_path
      expect(page).to have_content '503'
      visit task_schedule_index_path
      expect(page).to have_content '503'
      visit new_task_schedule_path
      expect(page).to have_content '503'
      visit task_schedule_path(task)
      expect(page).to have_content '503'
      visit edit_task_schedule_path(task)
      expect(page).to have_content '503'
    end
  end
end
