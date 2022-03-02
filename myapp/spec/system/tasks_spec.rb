require 'rails_helper'

RSpec.feature 'Tasks', type: :system do
  fixtures :tasks

  background do
    Capybara.current_driver = Capybara.javascript_driver
  end

  scenario 'タスク一覧画面　構成要素確認' do
    # タスク一覧画面を開く
    visit tasks_path

    expect(page).to have_content 'タスク一覧'

    expect(page).to have_link 'タスク作成'

    expect(page).to have_content 'タスク名'
    expect(page).to have_content 'ステータス'
    expect(page).to have_content '終了期限'
    expect(page).to have_content 'ラベル'

    expect(page).to have_link 'テストタスク１'
    expect(page).to have_content '未着手'
    expect(page).to have_content '2022-03-10'
    expect(page).to have_link '編集'
    expect(page).to have_link '削除'
  end

  scenario 'タスク作成画面　構成要素確認' do
    # タスク一覧画面からタスク作成画面を開く
    visit tasks_path
    click_link 'タスク作成'

    expect(page).to have_content 'タスク作成'

    expect(page).to have_link '一覧へ'

    expect(page).to have_field 'タスク名', with: ''
    expect(page).to have_field '内容', with: ''
    expect(page).to have_field '終了期限', with: ''
    expect(page).to have_field '優先順位', with: 'high'
    expect(page).to have_field 'ステータス', with: '未着手'
    expect(page).to have_field 'ラベル', with: ''

    expect(page).to have_button '登録'

    click_link '一覧へ'
    expect(page).to have_content 'タスク一覧'
  end

  scenario 'タスク編集画面　構成要素確認' do
    # タスク一覧画面からタスク編集画面を開く
    visit tasks_path
    click_link '編集', match: :first

    # 表示内容確認
    expect(page).to have_content 'タスク編集'

    expect(page).to have_content '一覧へ'

    expect(page).to have_field 'タスク名', with: 'テストタスク１'
    expect(page).to have_field '内容', with: 'テスト内容１'
    expect(page).to have_field '終了期限', with: '2022-03-10'
    expect(page).to have_field '優先順位', with: 'middle'
    expect(page).to have_field 'ステータス', with: '未着手'

    expect(page).to have_button '登録'

    click_link '一覧へ'
    expect(page).to have_content 'タスク一覧'
  end

  scenario 'タスク詳細画面　構成要素確認' do
    # タスク一覧画面からタスク詳細画面を開く
    visit tasks_path
    click_link 'テストタスク１', match: :first

    # 表示内容確認
    expect(page).to have_content 'タスク詳細'

    expect(page).to have_link '一覧へ'

    expect(page).to have_content 'タスク名'
    expect(page).to have_content '内容'
    expect(page).to have_content '終了期限'
    expect(page).to have_content '優先順位'
    expect(page).to have_content 'ステータス'
    expect(page).to have_content 'ラベル'

    expect(page).to have_content 'テストタスク１'
    expect(page).to have_content 'テスト内容１'
    expect(page).to have_content '2022-03-10'
    expect(page).to have_content 'middle'
    expect(page).to have_content '未着手'

    click_link '一覧へ'
    expect(page).to have_content 'タスク一覧'
  end

  scenario 'タスク削除　構成要素確認' do
    # タスク一覧画面を開く
    visit tasks_path

    # タスクの存在確認
    expect(page).to have_content 'テストタスク１'

    # タスク削除
    click_link '削除', match: :first

    # ダイアログ表示確認
    expect(page.driver.browser.switch_to.alert.text).to eq "削除します。よろしいですか？"
    page.driver.browser.switch_to.alert.accept

    # タスク一覧画面へ遷移
    expect(page).to have_content 'タスク一覧'
    # 削除成功メッセージ
    expect(page).to have_content '削除しました'
    # お試しタスクの削除確認
    expect(page).not_to have_content 'テストタスク１'
    # ０件メッセージ確認
    expect(page).to have_content 'タスクが登録されていません'
  end

  scenario 'タスク作成〜編集〜削除の通し動作確認' do
    # タスク作成画面を開く
    visit new_task_path

    expect(page).to have_content 'タスク作成'

    # タスク作成：入力
    fill_in 'task[title]', with: 'お試しタスク'
    fill_in 'task[body]', with: 'ないよー'
    fill_in 'task[deadline]', with: '03-10-2022' # mm-dd-yyyy
    select 'middle', from: 'task[priority]'
    select '着手', from: 'task[status]'

    click_button '登録'

    # タスク詳細画面へ遷移
    expect(page).to have_content 'タスク詳細'

    # 保存成功メッセージ
    expect(page).to have_content '保存しました'
    # 保存内容
    expect(page).to have_content 'お試しタスク'
    expect(page).to have_content 'ないよー'
    expect(page).to have_content '2022-03-10'
    expect(page).to have_content 'middle'
    expect(page).to have_content '着手'

    click_link '一覧へ'

    # タスク編集
    click_link '編集', match: :first

    expect(page).to have_content 'タスク編集'

    # 修正入力
    fill_in 'task[body]', with: '内容ないよー'
    fill_in 'task[deadline]', with: '03-09-2022' #mm-dd-yyyy
    select '完了', from: 'task[status]'

    click_button '登録'

    # タスク詳細画面へ遷移
    expect(page).to have_content 'タスク詳細'

    # 保存成功メッセージ
    expect(page).to have_content '保存しました'
    # 保存内容
    expect(page).to have_content 'テストタスク１'
    expect(page).to have_content '内容ないよー'
    expect(page).to have_content '2022-03-09'
    expect(page).to have_content 'middle'
    expect(page).to have_content '完了'

    click_link '一覧へ'

    # タスクの存在確認
    expect(page).to have_content 'テストタスク１'

    # タスク削除
    click_link '削除', match: :first

    # ダイアログ表示確認
    expect(page.driver.browser.switch_to.alert.text).to eq "削除します。よろしいですか？"
    page.driver.browser.switch_to.alert.accept

    # タスク一覧画面へ遷移
    expect(page).to have_content 'タスク一覧'
    # 削除成功メッセージ
    expect(page).to have_content '削除しました'

    # お試しタスクの削除確認
    expect(page).not_to have_content 'テストタスク１'

  end
end