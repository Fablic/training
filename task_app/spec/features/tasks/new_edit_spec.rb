# frozen_string_literal: true

require 'rails_helper'

shared_examples_for '正常処理とバリデーションエラーの確認' do |name, description|
  before do
    fill_in 'タスク名', with: task_name
    fill_in '説明', with: task_description
    select '高', from: 'task_priority'
    select '着手中', from: 'task_status'
    check "task_label_ids_#{label1.id}"
    # 期限を入力するとカレンダーのフォームが開いたままになりチェックボックスがelement not foundになる為、最後に入力
    fill_in '期限', with: '20190213'
    click_on('送信')
  end

  context '正常値を入力したとき' do
    let(:task_name) { name }
    let(:task_description) { description }

    scenario '正常に処理される' do
      expect(page).to have_selector '.alert-success'
      expect(page).to have_content name
      expect(page).to have_content '02/13'
      expect(page).to have_content '高'
      expect(page).to have_content '着手中'
      expect(page).to have_content 'ラベル1'
      expect(page.all('tbody tr').size).to eq 1
      expect(Task.count).to eq 1
    end
  end

  context '制限内の文字数を入力したとき' do
    let(:task_name) { 'a' * 30 }
    let(:task_description) { 'a' * 800 }

    scenario '正常に処理される' do
      expect(page).to have_no_selector '#error_explanation'
      expect(page).to have_selector '.alert-success'
    end
  end

  context '空欄のまま送信したとき' do
    let(:task_name) { '' }
    let(:task_description) { '' }

    scenario '入力を促すエラーメッセージが表示される' do
      expect(page).to have_selector '#error_explanation', text: 'タスク名を入力してください'
      expect(page).to have_selector '#error_explanation', text: '説明を入力してください'
    end
  end

  context '制限外の文字数を入力したとき' do
    let(:task_name) { 'a' * 31 }
    let(:task_description) { 'a' * 801 }

    scenario '文字数に関するエラーメッセージが表示される' do
      expect(page).to have_selector '#error_explanation', text: '30文字以内'
      expect(page).to have_selector '#error_explanation', text: '800文字以内'
    end
  end
end

feature 'タスク登録機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:label1) { FactoryBot.create(:label, name: 'ラベル1', user: user) }

  before do
    login(user, new_task_path)
  end

  context 'タスク一覧画面からボタンクリックで画面遷移したとき' do
    before do
      visit root_path
      page.find('.navbar-toggler').click
      page.find('#navbarTaskMenuLink').click
      page.click_link('タスク登録')
    end

    scenario 'タスク登録画面に遷移する' do
      expect(current_path).to eq new_task_path
    end
  end

  it_behaves_like '正常処理とバリデーションエラーの確認', '最初のタスク', '最初のタスクの説明'
end

feature 'タスク編集機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:label1) { FactoryBot.create(:label, name: 'ラベル1', user: user) }
  let!(:task) { FactoryBot.create(:task, user: user) }

  before do
    login(user)
    click_on('編集')
  end

  it_behaves_like '正常処理とバリデーションエラーの確認', '掃除', 'トイレ,風呂,キッチン'
end
