# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task1) { create(:task, title: 'タイトル1', end_at: Time.current.change(sec: 0, usec: 0)) }
  let!(:task2) { create(:past_task, title: 'タイトル2', end_at: Time.current.yesterday.change(sec: 0, usec: 0)) }

  describe 'タスク一覧' do
    context '正常時' do
      example 'タスク一覧が表示されている (/)' do
        visit root_path

        expect(page).to have_content 'タイトル1'
        expect(page).to have_content '説明'
        expect(page).to have_content I18n.l(task1.end_at)
      end

      example 'タスク一覧が表示されている (/tasks)' do
        visit tasks_path

        expect(page).to have_content 'タイトル1'
        expect(page).to have_content '説明'
        expect(page).to have_content I18n.l(task1.end_at)
      end

      example 'タスク一覧の順序が作成日降順' do
        visit tasks_path

        expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match 'タイトル1'
        expect(all(:xpath, '/html/body/div[2]/div[2]/div[2]/div/a')[0].text).to match 'タイトル2'
      end
    end

    it 'タスク一覧の終了期限を昇順に変更できる' do
      visit root_path(end_at: 'asc')

      expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match 'タイトル2'
      expect(all(:xpath, '/html/body/div[2]/div[2]/div[2]/div/a')[0].text).to match 'タイトル1'
    end

    it 'タスク一覧の終了期限を降順に変更できる' do
      visit root_path(end_at: 'desc')

      expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match 'タイトル1'
      expect(all(:xpath, '/html/body/div[2]/div[2]/div[2]/div/a')[0].text).to match 'タイトル2'
    end
  end

  describe 'タスク検索' do
    context '正常時' do
      let!(:doing_task) { create(:task, title: 'Railsを勉強する', task_status: :doing) }
      let!(:done_task) { create(:task, title: '英語を勉強する', task_status: :done) }

      it 'keyword検索ができる' do
        visit root_path(keyword: 'タイトル1')

        expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match 'タイトル1'
      end

      it 'status検索ができる(doing)' do
        visit root_path(task_status: :doing)

        expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match 'Railsを勉強する'
      end

      it 'status検索ができる(done)' do
        visit root_path(task_status: :done)

        expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match '英語を勉強する'
      end

      it 'keyword, status検索ができる' do
        visit root_path(keyword: '英語を勉強する', task_status: :done)

        expect(all(:xpath, '/html/body/div[2]/div[2]/div[1]/div/a')[0].text).to match '英語を勉強する'
      end
    end

    context '連続して検索条件を変更する' do
      let!(:doing_task) { create(:task, title: 'タスクの1番目', task_status: :todo) }
      let!(:doing_past_task) { create(:task, title: 'タスクの2番目', task_status: :todo, end_at: Time.current.yesterday.change(sec: 0, usec: 0)) }

      it 'keyword, statusで検索' do
        visit root_path(keyword: 'タイトル1')

        choose('todo')
        click_button 'Search'

        expect(all(:xpath, '/html/body/div[2]/div[2]/div').length).to match 1
      end

      it 'keyword, status, end_at: ascで検索' do
        visit root_path(keyword: 'タスク')

        choose('todo')
        click_button 'Search'
        click_link('👇')

        expect(all(:xpath, '/html/body/div[2]/div[2]/div').length).to match 2
      end

      it 'keyword, status, end_at: descで検索' do
        visit root_path(keyword: 'タスク')

        choose('todo')
        click_button 'Search'
        click_link('👆')

        expect(all(:xpath, '/html/body/div[2]/div[2]/div').length).to match 2
      end
    end
  end

  describe 'タスク詳細' do
    context '正常時' do
      example 'タスク詳細が表示される' do
        visit task_path(task1)
        expect(page).to have_content 'タイトル1'
        expect(page).to have_content '説明'
        expect(page).to have_content I18n.l(task1.end_at)
      end
    end
  end

  describe 'タスク編集' do
    context '正常時' do
      example 'タスクを変更できる' do
        visit edit_task_path(task1)
        fill_in 'task_title', with: 'hoge'
        fill_in 'task_description', with: 'fuga'
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'hoge'
        expect(page).to have_content 'fuga'
      end

      example 'タスクの終了期限を変更できる' do
        visit edit_task_path(task1)
        end_at_input = Time.current.change(sec: 0, usec: 0)

        fill_in 'task_title', with: 'hoge'
        fill_in 'task_end_at', with: end_at_input
        click_button I18n.t(:'button.edit')
        expect(page).to have_content I18n.l(end_at_input)
      end
    end

    context 'title 256文字以上を入力する' do
      example '登録に失敗しましたが表示されること' do
        visit edit_task_path(task1)
        fill_in 'task_title', with: Faker::Alphanumeric.alpha(number: 256)
        click_button 'Edit'
        expect(page).to have_content 'Edited is failed'
      end
    end

    context 'description 5001文字以上を入力する' do
      example '登録に失敗しましたが表示されること' do
        visit edit_task_path(task1)
        fill_in 'task_description', with: Faker::Alphanumeric.alpha(number: 5001)
        click_button 'Edit'
        expect(page).to have_content 'Edited is failed'
      end
    end

    context '未入力の状態' do
      example '登録に失敗しましたが表示されること' do
        visit edit_task_path(task1)
        fill_in 'task_title', with: ''
        fill_in 'task_description', with: ''
        click_button 'Edit'
        expect(page).to have_content 'Edited is failed'
      end
    end
  end

  describe 'タスク削除' do
    context '正常時' do
      example 'タスクを削除できる' do
        visit tasks_path

        first(:link, 'Delete').click
        expect(page).to_not have_content 'タイトル1'
        expect(page).to have_content 'タイトル2'
        expect(page).to have_content 'Task deleted is complete'
      end
    end
  end
end
