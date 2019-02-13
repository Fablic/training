# frozen_string_literal: true

require 'rails_helper'

feature 'タスク登録・編集機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  shared_examples_for '正常処理とバリデーションエラーの確認' do |action, name, description|
    before do
      login(user)

      if action == :create
        # ハンバーガーボタン→タスク管理→タスク登録の順でクリック(capybaraのscreen sizeはmd以下らしい。)
        page.find('.navbar-toggler').click
        page.find('#navbarTaskMenuLink').click
        page.click_link('タスク登録')

      elsif action == :update
        click_on('編集')
      end

      fill_in 'タスク名', with: task_name
      fill_in '説明', with: task_description
      fill_in '期限', with: '20190213'
      select '高', from: 'task_priority'
      select '着手中', from: 'task_status'
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

  feature '登録' do
    it_behaves_like '正常処理とバリデーションエラーの確認', :create, '最初のタスク', '最初のタスクの説明'
  end

  feature '編集' do
    let!(:first_task) { FactoryBot.create(:task, user: user) }
    it_behaves_like '正常処理とバリデーションエラーの確認', :update, '掃除', 'トイレ,風呂,キッチン'
  end
end
