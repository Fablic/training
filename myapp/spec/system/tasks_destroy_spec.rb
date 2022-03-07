require 'rails_helper'

RSpec.describe 'Tasks_destroy', type: :system do

  feature 'タスク削除' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context 'タスク一覧画面で削除をクリックする' do
      it '一覧からタスクが削除されている' do
        # タスク一覧画面を開く
        visit tasks_path
        # タスクの存在確認
        expect(page).to have_content @task1.title
        # タスク削除
        click_link '削除', match: :first

        # ダイアログ表示確認
        page.driver.browser.switch_to.alert.accept

        # タスク一覧画面へ遷移
        expect(page).to have_content 'タスク一覧'
        # 削除成功メッセージ
        expect(page).to have_content '削除しました'
        # お試しタスクの削除確認
        expect(page).not_to have_content @task1.title
      end
    end
  end
end
