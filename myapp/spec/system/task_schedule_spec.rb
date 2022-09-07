# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskSchedule', type: :system do
  before do
    @task = Task.create(title: 'showタスク', body: 'showボディ', finish_at: 1.year.from_now)
    @task2 = Task.create(title: 'secondタスク', body: 'secondボディ', created_at: 1.day.from_now, finish_at: 1.day.from_now)
    @task3 = Task.create(title: 'thirdタスク', body: 'thirdボディ', created_at: 1.day.ago, finish_at: 1.week.from_now, status: 2)
    visit task_schedule_index_path
  end

  context 'order systems check' do
    it 'initial display (finish_at asc)' do
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
    it 'complete new task create' do
      click_button 'タスク登録'
      expect(page).to have_content 'タスク登録画面'

      fill_in 'task[title]', with: 'newタスク'
      fill_in 'task[body]', with: 'newボディ'
      fill_in 'task[finish_at]', with: '9999-01-01'
      click_button '登録する'

      expect(page).to have_content 'タスクの登録が完了しました'
      expect(page).to have_content 'newタスク'
      expect(page).to have_content 'newボディ'
      expect(page).to have_content '9999/01/01'
      expect(page).to have_content '未着手'
    end

    it 'failure new task create' do
      click_button 'タスク登録'
      expect(page).to have_content 'タスク登録画面'

      fill_in 'task[title]', with: ''
      fill_in 'task[body]', with: 'newボディ'
      click_button '登録する'

      expect(page).to have_content '登録に失敗しました'
      expect(page).to have_content 'タスク名を入力してください'
      expect(page).to have_no_content 'タスク本文を入力してください'
      expect(page).to have_content '終了期限を入力してください'

      click_link '一覧に戻る'
      expect(page).to have_no_content 'newボディ'
    end
  end

  context 'show systems check' do
    it 'complete show task' do
      click_link('詳細', href: task_schedule_path(@task))
      expect(page).to have_content 'タスク詳細画面'
      expect(page).to have_content 'showタスク'
      expect(page).to have_content 'showボディ'

      select '着手中', from: 'task[status]'
      expect(page).to have_content '着手中'
    end
  end

  context 'edit systems check' do
    it 'complete edit task' do
      click_link('編集', href: edit_task_schedule_path(@task))
      expect(page).to have_content 'タスク編集画面'

      fill_in 'task[title]', with: 'editタスク'
      fill_in 'task[body]', with: 'editボディ'
      fill_in 'task[finish_at]', with: '2112-09-03'
      click_button '編集する'

      expect(page).to have_content 'タスクの編集が完了しました'
      expect(page).to have_no_content 'showタスク'
      expect(page).to have_no_content 'showボディ'
      expect(page).to have_content 'editタスク'
      expect(page).to have_content 'editボディ'
      expect(page).to have_content '2112/09/03'
    end

    it 'failure edit task' do
      click_link('編集', href: edit_task_schedule_path(@task))
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
  end

  context 'delete systems check' do
    it 'complete delete task' do
      click_link('削除', href: task_schedule_path(@task))
      expect do
        expect(page.accept_confirm).to eq '削除します。よろしいですか'
        exmect(page).to have_content 'タスクを削除しました'
        expect(page).to have_no_content 'showタスク'
        expect(page).to have_no_content 'showボディ'
      end
    end
  end

  context 'search systems check' do
    it 'complete title search' do
      fill_in 'search[title]', with: 'second'
      click_button '検索'
      expect(page).to have_content 'secondタスク'
      expect(page).to have_no_content 'thirdタスク'
    end

    it 'complete status search' do
      select '完了', from: 'search[status]'
      click_button '検索'
      expect(page).to have_content 'thirdタスク'
      expect(page).to have_no_content 'secondタスク'
    end
  end
end
