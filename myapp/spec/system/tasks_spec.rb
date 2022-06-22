require 'rails_helper'
include TasksHelper

RSpec.describe 'Tasks', type: :system do

  describe 'タスクの一覧を表示', type: :system do
    context '1件登録されているとき' do
      example 'タスクの各要素とEdit, Deleteボタンが表示' do
        task = FactoryBot.create(:task)
        visit root_path
        expect(page).to have_content task.title
        expect(page).to have_content parse_date task.expire_at
        expect(page).to have_content task.description
        expect(page).to have_content parse_date task.created_at
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
          expect(page).to have_content '2022/06/10 12:00'
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
        expect(page).to have_content 'edited desc'
        expect(page).to have_content '2022/06/10 00:00'
        expect(page).to have_content tasks[1].title
        expect(page).to have_content tasks[1].description
        expect(page).to have_content parse_date tasks[1].expire_at
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

  describe '作成日時でソート' do
    let!(:task_created_yesterday) {
      FactoryBot.create(:task, :created_yesterday)
    }
    let!(:task_created_1week_ago) {
      FactoryBot.create(:task, :created_1week_ago)
    }
    let!(:task_created_today) {
      FactoryBot.create(:task)
    }
    context '1度作成日時を押したとき' do
      example '降順にソート' do
        visit root_path
        click_link I18n.t('tasks.form.created_at')

        expect(page.body.index(task_created_today.title)).to be < page.body.index(task_created_yesterday.title)
        expect(page.body.index(task_created_yesterday.title)).to be < page.body.index(task_created_1week_ago.title)
      end
    end
    context '2度作成日時を押したとき' do
      example '昇順にソート' do
        visit root_path
        # 降順→昇順に切り替わる
        click_link I18n.t('tasks.form.created_at')
        click_link I18n.t('tasks.form.created_at')

        expect(page.body.index(task_created_1week_ago.title)).to be < page.body.index(task_created_yesterday.title)
        expect(page.body.index(task_created_yesterday.title)).to be < page.body.index(task_created_today.title)
      end
    end
  end

  describe '有効期限でソート' do
    let!(:task_expire_tomorrow) {
      FactoryBot.create(:task, :expire_tomorrow)
    }
    let!(:task_expire_next_month) {
      FactoryBot.create(:task, :expire_next_month)
    }
    let!(:task_expire_today) {
      FactoryBot.create(:task)
    }

    context '1度有効期限を押したとき' do
        # 降順→昇順に切り替わる
      example '降順にソート' do
        visit root_path
        click_link I18n.t('tasks.form.expire')

        expect(page.body.index(task_expire_next_month.title)).to be < page.body.index(task_expire_tomorrow.title)
        expect(page.body.index(task_expire_tomorrow.title)).to be < page.body.index(task_expire_today.title)
      end
    end
    context '2度有効期限を押したとき' do
      example '昇順にソート' do
        visit root_path
        click_link I18n.t('tasks.form.expire')
        click_link I18n.t('tasks.form.expire')

        expect(page.body.index(task_expire_today.title)).to be < page.body.index(task_expire_tomorrow.title)
        expect(page.body.index(task_expire_tomorrow.title)).to be < page.body.index(task_expire_next_month.title)
      end
    end
  end

  describe '検索' do
    let!(:task_hoge) {
      FactoryBot.create(:task, title: 'hogehoge', created_at: Time.current)
    }
    let!(:task_fuga) {
      FactoryBot.create(:task, title: 'fugafuga', created_at: Time.current.tomorrow)
    }
    let!(:task_complete) {
      FactoryBot.create(:task, :status_completed, created_at: Time.current.yesterday)
    }

    context 'タイトルで検索' do
      example 'タイトルが部分一致したタスクが表示' do
        visit root_path
        fill_in :title, with: 'hoge'
        click_button 'commit'
        expect(page).to have_content task_hoge.title
        # hoge が含まれていないタスクは非表示
        expect(page).not_to have_content task_fuga.title
        expect(page).not_to have_content task_complete.title        
      end
    end
    context 'ステータスで検索' do
      example 'ステータスが一致したタスクが表示' do
        visit root_path
        select 'completed', from: 'status'
        click_button 'commit'
        expect(page).to have_content task_complete.title
        # completed以外は非表示
        expect(page).not_to have_content task_hoge.title
        expect(page).not_to have_content task_fuga.title    
      end
    end
    context '検索した後作成日時でソート' do
      example '降順にソート' do
        visit root_path
        # 条件を指定せず検索
        click_button 'commit'
        click_link I18n.t('tasks.form.created_at')

        expect(page.body.index(task_fuga.title)).to be < page.body.index(task_hoge.title)
        expect(page.body.index(task_hoge.title)).to be < page.body.index(task_complete.title)
      end
    end
  end
end
