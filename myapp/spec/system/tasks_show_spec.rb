require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  feature 'タスク詳細' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク詳細画面を開く
        visit task_path(@task1.id)

        expect(page).to have_content 'タスク詳細'

        expect(page).to have_link '一覧へ'
    
        expect(page).to have_content 'タスク名'
        expect(page).to have_content '内容'
        expect(page).to have_content '終了期限'
        expect(page).to have_content '優先順位'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content 'ラベル'
    
        expect(page).to have_content @task1.title
        expect(page).to have_content @task1.body
        expect(page).to have_content @task1.deadline
        expect(page).to have_content @task1.priority
        expect(page).to have_content @task1.status
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク詳細画面を開く
        visit task_path(@task1.id)
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end
  end
end
