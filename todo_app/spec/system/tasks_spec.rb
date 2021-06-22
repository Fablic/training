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

        expect(all('tbody tr')[1].text).to match 'タイトル1'
        expect(all('tbody tr')[2].text).to match 'タイトル2'
      end
    end

    it 'タスク一覧の終了期限を昇順に変更できる' do
      visit root_path(end_at: 'asc')

      expect(all('tbody tr')[1].text).to match task2.title
      expect(all('tbody tr')[2].text).to match task1.title
    end

    it 'タスク一覧の終了期限を降順に変更できる' do
      visit root_path(end_at: 'desc')

      expect(all('tbody tr')[1].text).to match task1.title
      expect(all('tbody tr')[2].text).to match task2.title
    end
  end
  describe 'タスク検索' do
    context '正常時' do
      visit search_path
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
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end
    end

    context 'description 5001文字以上を入力する' do
      example '登録に失敗しましたが表示されること' do
        visit edit_task_path(task1)
        fill_in 'task_description', with: Faker::Alphanumeric.alpha(number: 5001)
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end
    end

    context '未入力の状態' do
      example '登録に失敗しましたが表示されること' do
        visit edit_task_path(task1)
        fill_in 'task_title', with: ''
        fill_in 'task_description', with: ''
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end
    end
  end

  describe 'タスク削除' do
    context '正常時' do
      example 'タスクを削除できる' do
        visit tasks_path
        all('tbody tr td')[4].click_link 'Delete'
        expect(page).to_not have_content 'タイトル1'
        expect(page).to have_content 'タイトル2'
      end
    end
  end
end
