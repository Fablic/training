require 'rails_helper'

RSpec.describe 'Tasks_new', type: :system do

  feature 'タスク作成' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク作成画面を開く
        visit new_task_path
    
        expect(page).to have_content 'タスク作成'
    
        expect(page).to have_link '一覧へ'
    
        expect(page).to have_field 'タスク名', with: ''
        expect(page).to have_field '内容', with: ''
        expect(page).to have_field '終了期限', with: ''
        expect(page).to have_field '優先順位', with: 'high'
        expect(page).to have_field 'ステータス', with: '未着手'
        expect(page).to have_field 'ラベル', with: ''
    
        expect(page).to have_button '登録'
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク作成画面を開く
        visit new_task_path
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end

    context '項目を入力して、登録ボタンをクリックする' do
      it '新規タスクを保存して、タスク詳細画面へ遷移する' do
        # タスク作成画面を開く
        visit new_task_path

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
      end
    end
  end
end
