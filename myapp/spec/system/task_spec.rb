# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let!(:task_a) { FactoryBot.create(:task) }

  describe 'タスク一覧表示機能' do
    context 'タスク一覧にアクセスしたとき' do
      it 'タスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'task_name'
      end
    end
  end

  describe 'タスク詳細表示機能' do
    context 'タスク一覧のタスク名をクリックしたとき' do
      it 'タスク詳細ページが表示される' do
        visit task_path(task_a)
        expect(page).to have_content 'task_name'
      end
    end
  end

  describe 'タスク新規作成機能' do
    context '新しいタスクを登録したとき' do
      it 'タスクが登録されタスク一覧に表示される' do
        visit new_task_path
        fill_in 'todo',	with: '新しいタスク'
        click_button 'Create Task'
        expect(page).to have_content '新しいタスク'
      end
    end
  end

  describe 'タスク編集機能' do
    context '既存のタスクを編集したとき' do
      it 'タスクが編集がされタスク一覧に反映される' do
        visit tasks_path
        click_on 'Edit'
        fill_in 'todo',	with: '編集したタスク'
        click_on 'Update Task'
        expect(page).to have_content '編集したタスク'
      end
    end
  end

  describe 'タスク削除機能' do
    context '既存のタスクを削除したとき' do
      it 'タスクが削除がされタスク一覧に表示されない' do
        visit tasks_path
        click_on 'Delete'
        expect(page).to have_no_selector 'td', text: 'task_name'
      end
    end
  end
end
