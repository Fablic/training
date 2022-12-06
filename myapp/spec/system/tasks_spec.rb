# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Test cases for Task :', type: :system do
  describe 'In task list page' do
    context 'when there is no task,' do
      before do
        # 一覧画面を開く
        visit tasks_path
      end
      it 'does not show any task' do
        # 正しい情報が表示されていること
        expect(page).to have_content I18n.translate('tasks.index.title')
        expect(Task.count).to eq 0
      end
    end

    context 'when there are tasks,' do
      before do
        @task1 = Task.create!(title: 'Spec', description: 'test')
        @task2 = Task.create!(title: 'Spec2', description: 'test2')
  
        # 一覧画面を開く
        visit tasks_path
      end

      it 'shows correct result' do
        # 正しい情報が表示されていること
        expect(page).to have_content I18n.translate('tasks.index.title')
        expect(page).to have_content 'Spec'
        expect(page).to have_content 'test'
        expect(page).to have_content 'Spec2'
        expect(page).to have_content 'test2'
        expect(Task.count).to eq 2
      end

      it 'sorts correctly after push sort button: latest' do
        click_link I18n.translate('tasks.index.sort.latest')

        expect(page).to have_content I18n.translate('tasks.index.title')
        # 正規表現で並び順をチェック
        expect(page.text).to match(/Spec2.*Spec/)
        expect(Task.count).to eq 2
      end
    end
  end

  describe 'New task page' do
    it 'create task correctly' do
      # 新規画面を開く
      visit new_task_path

      # 新規画面が開いてること（titleが空白になってる）
      expect(page).to have_content I18n.translate('tasks.new.title')
      expect(find_field('task_title').text).to be_blank
      expect(page).to have_field 'task_description', with: ''

      # titleとdescriptionを入力
      fill_in 'task_title', with: 'Spec test new task'
      fill_in 'task_description', with: 'Spec test new task description'

      # 登録
      click_button I18n.translate('helpers.submit.create', model: Task.model_name.human)

      # 正しく登録されていること
      expect(page).to have_content I18n.translate('tasks.show.title')
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
      expect(page).to have_content I18n.translate('tasks.show.title')
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
      expect(page).to have_content I18n.translate('tasks.edit.title')
      expect(page).to have_field 'task_title', with: 'Spec'
      expect(page).to have_field 'task_description', with: 'test'

      # titleとdescriptionを入力する
      fill_in 'task_title', with: 'Spec first task'
      fill_in 'task_description', with: 'Spec first task description'

      # 更新実行
      click_button I18n.translate('helpers.submit.update', model: Task.model_name.human)

      # 正しく更新されていること
      expect(page).to have_content I18n.translate('tasks.show.title')
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
      click_link I18n.translate('common.delete')
      expect do
        expect(page.accept_confirm).to eq I18n.translate('common.messages.confirm_delete')
        sleep 0.5
      end.to change(Task, :count).by(-1)
      is_expected.not_to have_content 'Spec'
      is_expected.not_to have_content 'test'
    end
  end
end
