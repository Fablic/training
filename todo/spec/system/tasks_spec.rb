# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:task1) { create(:task, title: 'タスク１', description: 'タスク１詳細', status: :todo, due_date: Time.zone.local(2020, 1, 1, 0, 0)) }
  let(:task2) { create(:task, title: 'タスク２', description: 'タスク２詳細', status: :doing, due_date: Time.zone.local(2021, 1, 1, 0, 0)) }

  describe 'when show tasks' do
    context 'sort' do
      it 'by link' do
        visit tasks_new_path
        fill_in 'task_title', with: 'first'
        fill_in 'task_due_date', with: Time.zone.local(2021, 1, 1, 0, 0)
        click_button '追加'

        visit tasks_new_path
        fill_in 'task_title', with: 'second'
        fill_in 'task_due_date', with: Time.zone.local(2020, 1, 1, 0, 0)
        click_button '追加'

        within('table.task-list') do
          expect(page.text).to match(/second\nfirst/)
        end

        click_link '終了期限'
        sleep(0.5)
        within('table.task-list') do
          expect(page.text).to match(/first\nsecond/)
        end

        click_link '作成日'
        sleep(0.5)
        within('table.task-list') do
          expect(page.text).to match(/second\nfirst/)
        end
      end
    end

    context 'paginate' do
      let!(:task_list) { create_list(:task, 60) }
      it 'go next' do
        visit tasks_path

        expect(page).to have_content('テストタスク', count: 25)
        click_link '次へ', match: :first

        expect(page).to have_content('テストタスク', count: 25)
        click_link '最後へ', match: :first

        expect(page).to have_content('テストタスク', count: 10)
      end

      it 'go back' do
        visit tasks_path
        click_link '最後へ', match: :first

        expect(page).to have_content('テストタスク', count: 10)
        click_link '前へ', match: :first

        expect(page).to have_content('テストタスク', count: 25)
        click_link '最初へ', match: :first

        expect(page).to have_content('テストタスク', count: 25)
      end
    end

    context 'search' do
      it 'by title' do
        visit tasks_show_path(task1)
        visit tasks_show_path(task2)
        visit tasks_path

        fill_in 'title', with: 'タスク２'
        click_button '検索'

        expect(page).to have_content 'タスク２'
        expect(page).not_to have_content 'タスク１'
      end

      it 'by status' do
        visit tasks_show_path(task1)
        visit tasks_show_path(task2)
        visit tasks_path
        select '着手', from: 'status'
        click_button '検索'

        expect(page).to have_content 'タスク２'
        expect(page).not_to have_content 'タスク１'
      end
    end
  end

  it 'show task detail' do
    visit tasks_show_path(task1)

    expect(page).to have_content 'タスク１'
    expect(page).to have_content 'タスク１詳細'
    expect(page).to have_content '未着手'
  end

  describe 'when create new task' do
    context 'with valid attributes' do
      it 'fill all items' do
        visit tasks_new_path
        fill_in 'task_title', with: '新規タスク'
        fill_in 'task_description', with: '新規タスク詳細'
        select '着手', from: 'task_status'

        click_button '追加'

        expect(page).to have_content 'Success!'
        expect(page).to have_content '新規タスク'
      end
    end

    context 'with invalid attributes' do
      it 'no title' do
        visit tasks_new_path
        click_button '追加'
        expect(page).to have_content 'タスク名 を入力してください'
      end

      it 'too long title' do
        visit tasks_new_path
        fill_in 'task_title', with: 'a' * 251
        click_button '追加'
        expect(page).to have_content 'タスク名 が長すぎます'
      end
    end
  end

  describe 'when update task' do
    context 'with valid attributes' do
      it 'fill all items' do
        visit tasks_edit_path(task1)

        expect(page).to have_field 'task_title', with: 'タスク１'
        expect(page).to have_field 'task_description', with: 'タスク１詳細'
        expect(page).to have_select 'task_status',
                                    selected: '未着手',
                                    options: %w[未着手 着手 完了]

        time = Time.zone.local(2020, 10, 10, 10, 10)
        fill_in 'task_title', with: 'タスク１修正'
        fill_in 'task_description', with: 'タスク１詳細修正'
        fill_in 'task_due_date', with: time
        select '完了', from: 'task_status'

        click_button '更新'

        expect(page).to have_content 'Success!'
        expect(page).to have_content 'タスク１修正'
      end
    end

    context 'with invalid attributes' do
      it 'no title' do
        visit tasks_edit_path(task1)
        fill_in 'task_title', with: ''
        click_button '更新'
        expect(page).to have_content 'タスク名 を入力してください'
      end

      it 'too long title' do
        visit tasks_edit_path(task1)
        fill_in 'task_title', with: 'a' * 251
        click_button '更新'
        expect(page).to have_content 'タスク名 が長すぎます'
      end
    end
  end

  it 'delete task' do
    visit tasks_show_path(task1)

    click_link '削除'

    expect(page).to have_content 'Deleted'
    expect(page).to have_no_content 'タスク１'
  end
end
