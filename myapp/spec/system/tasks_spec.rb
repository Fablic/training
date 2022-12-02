# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Test cases for Task', type: :system do
  describe 'Task list page' do
    it 'shows correct result when there is no task' do
      # 一覧画面を開く
      visit tasks_path

      # 正しい情報が表示されていること
      expect(page).to have_content 'Tasks'
      expect(Task.count).to eq 0
    end

    it 'shows correct result when there are multiple tasks' do
      @task1 = Task.create!(title: 'Spec', description: 'test')
      @task2 = Task.create!(title: 'Spec2', description: 'test2')

      # 一覧画面を開く
      visit tasks_path

      # 正しい情報が表示されていること
      expect(page).to have_content 'Tasks'
      expect(page).to have_content 'Spec'
      expect(page).to have_content 'test'
      expect(page).to have_content 'Spec2'
      expect(page).to have_content 'test2'
      expect(Task.count).to eq 2
    end
  end

  describe 'New task page' do
    it 'create task correctly' do
      # 新規画面を開く
      visit new_task_path

      # 新規画面が開いてること（titleが空白になってる）
      expect(page).to have_content 'New Task'
      expect(find_field('task_title').text).to be_blank
      expect(page).to have_field 'task_description', with: ''

      # titleとdescriptionを入力
      fill_in 'task_title', with: 'Spec test new task'
      fill_in 'task_description', with: 'Spec test new task description'

      # 登録
      click_button 'Create Task'

      # 正しく登録されていること
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'Spec test new task'
      expect(page).to have_content 'Spec test new task description'
    end
  end

  describe 'Task detail page' do
    before do
      @task = Task.create!(title: 'Spec', description: 'test')
    end
    it 'shows result correctly' do
      # 詳細画面を開く
      visit task_path(@task)

      # 正しい情報が表示されていること
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'Spec'
      expect(page).to have_content 'test'
    end
  end

  describe 'Edit task page' do
    before do
      @task = Task.create!(title: 'Spec', description: 'test')
    end
    it 'works correctly' do
      # タスク編集画面を開く
      visit edit_task_path(@task)

      # titleとdescriptionが正しく表示されること
      expect(page).to have_content 'Edit Task'
      expect(page).to have_field 'task_title', with: 'Spec'
      expect(page).to have_field 'task_description', with: 'test'

      # titleとdescriptionを入力する
      fill_in 'task_title', with: 'Spec first task'
      fill_in 'task_description', with: 'Spec first task description'

      # 更新実行
      click_button 'Update Task'

      # 正しく更新されていること
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'Spec first task'
      expect(page).to have_content 'Spec first task description'
    end
  end

  describe 'Delete task button' do
    before do
      @task = Task.create!(title: 'Spec', description: 'test')
    end
    it 'works correctly', js: true do
      visit task_path(@task)
      click_link 'Destroy'
      expect do
        expect(page.accept_confirm).to eq 'Are you sure?'
        sleep 0.5
      end.to change(Task, :count).by(-1)
      is_expected.not_to have_content 'Spec'
      is_expected.not_to have_content 'test'
    end
  end
end
