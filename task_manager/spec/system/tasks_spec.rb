# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = FactoryBot.create(:task)
  end

  it '一覧ページの確認' do
    # Task編集画面を開く
    visit tasks_path

    # 画面を検証する
    expect(page).to have_content 'MyString'
  end

  it '詳細ページの確認' do
    # Task編集画面を開く
    visit task_path(@task)

    # 画面を検証する
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'Memo'
    expect(page).to have_content 'normal'
    expect(page).to have_content 'InProgress'
  end

  it '編集が行われているかの確認' do
    # Task編集画面を開く
    visit edit_task_path(@task)

    # メモに"Memo"が入力されていることを検証する
    expect(page).to have_field 'メモ', with: 'Memo'

    # メモを再入力
    fill_in 'メモ', with: 'MyText'

    # 更新実行
    click_button '投稿'

    # 画面を検証する
    expect(page).to have_content 'タスクが編集されました'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end

  it '新規作成が行われるかの確認' do
    # Task新規作成画面を開く
    visit new_task_path

    # タスクを入力
    fill_in 'タスク', with: 'Task'
    # メモを入力
    fill_in 'メモ', with: 'Memo'
    # 締め切りを入力
    fill_in '締め切り', with: '2021-08-17 10:59:26'
    # 優先順位を入力
    select '中', from: '優先順位'
    # 進捗状況を入力
    select 'InProgress', from: '進捗状況'
    # 更新実行
    click_button '投稿'

    # 画面を検証する
    expect(page).to have_content 'タスクが投稿されました'
    expect(page).to have_content 'Task'
    expect(page).to have_content 'Memo'
    expect(page).to have_content 'normal'
    expect(page).to have_content 'InProgress'
  end

  it '削除の確認' do
    visit task_path(@task)
    page.accept_confirm do
      click_on :delete_button
    end

    # 画面を検証する
    expect(page).to have_content 'タスクが削除されました'
  end
end
