require 'rails_helper'

RSpec.feature Task, type: :feature, js: true do
  # 画面ラベル名
  let(:label_name_task) { 'タスク名' }
  let(:label_name_detail) { '詳細' }
  let(:button_name_regist) { '登録' }
  let(:button_name_edit) { '更新' }

  # task-C
  feature '新規登録画面' do
    background do
      # タスク新規登録画面へ遷移
      visit new_task_path
    end
    context 'フォームの入力値が正常の場合' do
      scenario 'タスクの新規作成が成功' do
        input_name = 'ガス閉栓手続き'
        input_description = '京葉ガスに連絡・日付確定'

        # フィールドに入力
        fill_in label_name_task, with: input_name
        fill_in label_name_detail, with: input_description
        # submitをクリックする
        click_button button_name_regist
        # index_pathへ遷移することを期待する
        expect(current_path).to eq tasks_path
        # メッセージが出ていることを確認
        expect(page).to have_content 'タスクを登録しました'
        # 登録したタスクが表示されていることを確認
        expect(page).to have_content input_name
      end
    end
    context 'Name未記入の場合' do
      scenario 'タスク登録失敗する' do
        # 入力
        fill_in label_name_task, with: nil
        fill_in label_name_detail, with: '引っ越し業者の選定'
        # ボタンをクリック
        click_button button_name_regist
        # エラーメッセージが出ていることを確認
        expect(page).to have_content 'タスク名を入力してください'
      end
    end
    context 'description未記入の場合' do
      scenario 'タスク登録失敗する' do
        # 入力
        fill_in label_name_task, with: '電気の手続き'
        fill_in label_name_detail, with: nil
        # ボタンをクリック
        click_button button_name_regist
        # 完了メッセージが出ていることを確認
        expect(page).to have_content '詳細を入力してください'
      end
    end
  end

  # 更新
  feature '更新画面' do
    scenario '成功する' do
      task1 = FactoryBot.create(:task)
      input_new_task_name = 'タスク名更新'
      visit edit_task_path(id: task1.id)

      fill_in label_name_task, with: input_new_task_name
      click_button button_name_edit
      expect(page).to have_content 'タスクを更新しました'
      expect(page).to have_content input_new_task_name
    end
  end

  # 削除挙動確認
  feature '一覧から削除実行' do
    background do
      FactoryBot.create(:task)
    end
    scenario '削除成功する' do
      visit tasks_path
      page.first('.del_button').click
      expect do
        page.accept_confirm '削除しますか？'
        expect(page).to have_content 'タスクを削除しました。'
      end.to change { Task.count }.by(-1)
    end
  end
end
