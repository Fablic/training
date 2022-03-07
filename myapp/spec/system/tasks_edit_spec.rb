require 'rails_helper'

RSpec.describe 'Tasks_edit', type: :system do

  feature 'タスク編集' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク編集画面を開く
        visit edit_task_path(@task1.id)
    
        expect(page).to have_content 'タスク編集'
    
        expect(page).to have_link '一覧へ'
    
        expect(page).to have_field 'タスク名', with: @task1.title
        expect(page).to have_field '内容', with: @task1.body
        expect(page).to have_field '終了期限', with: @task1.deadline
        expect(page).to have_field '優先順位', with: @task1.priority
        expect(page).to have_field 'ステータス', with: @task1.status
        expect(page).to have_field 'ラベル', with: ''
    
        expect(page).to have_button '登録'
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク編集画面を開く
        visit edit_task_path(@task1.id)
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end

    context '項目を入力して、登録ボタンをクリックする' do
      it '新規タスクを保存して、タスク詳細画面へ遷移する' do
        # タスク編集画面を開く
        visit edit_task_path(@task1.id)

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
        expect(page).to have_content @task1.title
        expect(page).to have_content '内容ないよー'
        expect(page).to have_content '2022-03-09'
        expect(page).to have_content @task1.priority
        expect(page).to have_content '完了'
      end
    end
  end
end
