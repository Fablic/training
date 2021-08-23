# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task) { FactoryBot.create(:task) }

  context '一覧ページの確認' do
    # Task一覧画面を開く
    let!(:new_task) { FactoryBot.create(:new_task) }
    before { visit tasks_path }

    it '一覧表示されているかの確認' do
      # 画面を検証する
      expect(page).to have_content 'a_task'
    end

    it '初期のsort順序の確認' do
      expect(page).to have_selector '#task-0', text: '2021-08-02'
      expect(page).to have_selector '#task-1', text: '2019-09-02'
    end

    it '名前ボタンを押した際のsort確認' do
      find('a', text: 'タスク名').click
      expect(page).to have_selector '#task-0', text: 'a_task'
      expect(page).to have_selector '#task-1', text: 'b_task'
    end

    it '作成日ボタンを押した際のsort確認' do
      find('a', text: '作成日').click
      expect(page).to have_selector '#task-0', text: '2019-09-02'
      expect(page).to have_selector '#task-1', text: '2021-08-02'
    end
  end

  it '詳細ページの確認' do
    # Task編集画面を開く
    visit task_path(task)

    # 画面を検証する
    expect(page).to have_content 'a_task'
    expect(page).to have_content 'Memo'
    expect(page).to have_content '中'
    expect(page).to have_content '進行中'
  end

  context '編集が行われているかの確認' do
    # Task編集画面を開く
    before { visit edit_task_path(task) }

    it '既存のタスク内容が書いている' do
      expect(page).to have_field 'メモ', with: 'Memo'
    end

    it 'タスクを編集できる' do
      # メモに"Memo"が入力されていることを検証する
      # メモを再入力
      fill_in 'メモ', with: 'MyText'

      # 更新実行
      click_button '投稿'

      # 画面を検証する
      expect(page).to have_content 'タスクが編集されました'
      expect(page).to have_content 'a_task'
      expect(page).to have_content 'MyText'
    end
  end

  context '新規作成できるかの確認' do
    # Task新規作成画面を開く
    before { visit new_task_path }

    it '全ての項目を入力して成功する' do
      # タスクを入力
      fill_in 'タスク', with: 'Task'
      # メモを入力
      fill_in 'メモ', with: 'Memo'
      # 締め切りを入力
      fill_in '締め切り', with: '2021-08-17 10:59:26'
      # 優先順位を入力
      select '中', from: '優先順位'
      # 進捗状況を入力
      select '進行中', from: '進捗状況'
      # 更新実行
      click_button '投稿'

      # 画面を検証する
      expect(page).to have_content 'タスクが投稿されました'
      expect(page).to have_content 'Task'
      expect(page).to have_content 'Memo'
      expect(page).to have_content '中'
      expect(page).to have_content '進行中'
    end
  end

  it '削除の確認' do
    visit task_path(task)
    page.accept_confirm do
      click_on :delete_button
    end

    # 画面を検証する
    expect(page).to have_content 'タスクが削除されました'
  end
end
