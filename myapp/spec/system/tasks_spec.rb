require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'タスクの一覧を表示', type: :system do
    context '1件登録されているとき' do
      example 'タスクの各要素とEdit, Deleteボタンが表示' do
        task = FactoryBot.create(:task)
        visit root_path
        expect(page).to have_content task.title
        expect(page).to have_content task.expire_at
        expect(page).to have_content task.description
        expect(page).to have_content task.created_at
        expect(page).to have_content I18n.t('tasks.index.create')
        expect(page).to have_content I18n.t('tasks.index.edit')
        expect(page).to have_content I18n.t('tasks.index.delete')
      end
    end
  end

  describe '新しいタスクを作成', type: :system do
    context '正しいデータを入力したとき' do
      example 'タスクが追加され、flashメッセージが表示' do
        expect do
          visit root_path
          click_link I18n.t('tasks.index.create')
          fill_in I18n.t('tasks.form.title'), with: 'test title'
          fill_in I18n.t('tasks.form.description'), with: 'test description'
          fill_in I18n.t('tasks.form.expire'), with: '2022-06-10 12:00:00'
          click_button I18n.t('tasks.form.save')

          expect(page).to have_content 'Task created!'
          expect(page).to have_content 'test title'
          expect(page).to have_content 'test description'
          expect(page).to have_content '2022-06-10 12:00:00'
        end.to change(Task, :count).by(1)
      end
    end

    context 'タイトルが空欄のとき' do
      example '追加されずにエラーメッセージが表示' do
        visit root_path
        click_link I18n.t('tasks.index.create')
        fill_in I18n.t('tasks.form.description'), with: 'test description'
        fill_in I18n.t('tasks.form.expire'), with: '2022-06-10 12:00:00'
        click_button I18n.t('tasks.form.save')

        expect(page).to have_content I18n.t('errors.messages.blank')
      end
    end
  end

  # 編集して更新できる
  describe 'タスクを編集して更新' do
    context '1件正しいデータで更新したとき' do
      example '1件目のタスクのみが更新して表示され、flashメッセージが表示' do
        tasks = FactoryBot.create_list(:task, 2)

        visit root_path
        find_by_id("edit-#{tasks[0].id}").click

        fill_in I18n.t('tasks.form.title'), with: 'edited title'
        fill_in I18n.t('tasks.form.description'), with: 'edited desc'
        fill_in I18n.t('tasks.form.expire'), with: '2022-06-10 00:00:00'
        click_button I18n.t('tasks.form.save')

        expect(page).to have_content 'Task updated!'
        expect(page).to have_content 'edited title'
        expect(page).to have_content '2022-06-10 00:00:00'

        expect(page).to have_content tasks[1].title
        expect(page).to have_content tasks[1].expire_at
      end
    end

    context 'タイトルが空欄のとき' do
      example '更新されずにエラーメッセージが表示' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task)
        fill_in I18n.t('tasks.form.title'), with: ''
        click_button I18n.t('tasks.form.save')

        expect(page).to have_content I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'タスクの詳細', type: :system do
    context '1件登録されているとき' do
      example 'タスクの各要素を全て表示' do
        task = FactoryBot.create(:task)
        visit root_path
        click_link task.title

        expect(page).to have_content I18n.t('tasks.show.detail')
        expect(page).to have_content task.title
        expect(page).to have_content task.description
        expect(page).to have_content task.expire_at
      end
    end
  end

  describe 'タスクの削除' do
    context '2件登録されているとき' do
      example '1件目のタスクを削除し、2件目のみが表示され、flashメッセージが表示' do
        expect  do
          tasks = FactoryBot.create_list(:task, 2)
          visit root_path
          find_by_id("delete-#{tasks[0].id}").click
          expect(page).to have_content tasks[1].title
        end.to change(Task, :count).by(1)

        expect(page).to have_content 'Task deleted!'
      end
    end
  end
end
