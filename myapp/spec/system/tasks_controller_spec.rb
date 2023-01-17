require 'rails_helper'

RSpec.describe Task, type: :system do
    
  describe '新規登録機能' do
    context '全てのフォームの入力値が正常' do
      it 'タスクの新規作成が成功' do
        # タスク新規登録画面へ遷移
        Rails.logger.debug "new_task_path: #{new_task_path}"
        visit new_task_path
        # titleフィールドにtesttitle1と入力
        fill_in 'task[title]', with: 'testtitle1'
        # contentフィールドにtestcontent1と入力
        fill_in 'task[content]', with: 'testcontent1'
        # priorityフィールドに1と入力
        find("#task_priority").find("option[value='1']").select_option
        # statusフィールドに1と入力
        find("#task_status").find("option[value='1']").select_option
        # due_dateフィールドに2022-01-06 18:00:00と入力
        fill_in 'task[due_date]', with: '2022-01-06 18:00:00 +0900'
        # 登録と記述のあるsubmitをクリックする
        click_button '登録'
        # tasks_path(タスク一覧)へ遷移することを期待する
        expect(current_path).to eq tasks_path
        # 登録完了メッセージの確認
        expect(page).to have_content '登録が完了しました'
      end
    end
  end

  describe '編集機能' do

    let(:task) { create(:task) }
    let(:other_task) { create(:task) }

    context '全てのフォームの入力値が正常' do
      it 'タスクの編集が成功' do
        # タスク編集画面へ遷移
        visit edit_task_path(task)
        # titleフィールドにtesttitle2と入力
        fill_in 'task[title]', with: 'testtitle2'
        # contentフィールドにtestcontent1と入力
        fill_in 'task[content]', with: 'testcontent2'
        # priorityフィールドに2と入力
        find("#task_priority").find("option[value='2']").select_option
        # statusフィールドに1と入力
        find("#task_status").find("option[value='1']").select_option
        # due_dateフィールドに2022-01-06 18:00:00と入力
        fill_in 'task[due_date]', with: '2022-01-11 18:00:00 +0900'
        # 登録と記述のあるsubmitをクリックする
        click_button '登録'
        # tasks_path(タスク一覧)へ遷移することを期待する
        expect(current_path).to eq tasks_path
        # 更新完了メッセージの表示
        expect(page).to have_content '更新が完了しました'
      end
    end
  end

  describe '削除機能' do

    let(:task) { create(:task) }
    let(:other_task) { create(:task) }

    it 'taskの投稿が削除される' do
      # タスク詳細画面へ遷移
      visit task_path(task)
      # 削除と記述のあるsubmitをクリックする
      click_link '削除'
      # tasks_path(タスク一覧)へ遷移することを期待する
      expect(current_path).to eq tasks_path
      # 削除完了メッセージの表示
      expect(page).to have_content 'タスクを削除しました'

    end
  end
end
