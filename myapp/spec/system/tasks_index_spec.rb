require 'rails_helper'

RSpec.describe 'Tasks_index', type: :system do

  feature 'タスク一覧(登録タスクが0件)' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク一覧画面を開く
        visit tasks_path

        expect(page).to have_content 'タスク一覧'
        # ０件メッセージ確認
        expect(page).to have_content 'タスクが登録されていません'
      end
    end
  end

  feature 'タスク一覧' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク一覧画面を開く
        visit tasks_path

        expect(page).to have_content 'タスク一覧'

        expect(page).to have_link 'タスク作成'

        expect(page).to have_content 'タスク名'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content '終了期限'
        expect(page).to have_content 'ラベル'

        expect(page).to have_link @task1.title
        expect(page).to have_content @task1.status
        expect(page).to have_content @task1.deadline
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
      end
    end

    context 'タスク名をクリックする' do
      it 'タスク詳細画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link @task1.title

        expect(page).to have_content 'タスク詳細'
      end
    end

    context 'タスク作成リンクをクリックする' do
      it 'タスク作成画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link 'タスク作成'

        expect(page).to have_content 'タスク作成'
      end
    end

    context '編集リンクをクリックする' do
      it 'タスク編集画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link '編集', match: :first

        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除リンクをクリックする' do
      it '削除確認ダイアログを表示する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link '削除', match: :first

        expect(page.driver.browser.switch_to.alert.text).to eq "削除します。よろしいですか？"
      end
    end
  end
end
