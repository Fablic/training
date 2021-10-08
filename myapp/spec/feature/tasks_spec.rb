require 'rails_helper'

RSpec.feature Task, type: :feature, js: true do
  # 画面ラベル名
  let(:label_name_task) { 'タスク名' }
  let(:label_name_detail) { '詳細' }
  let(:label_name_due_date) { '終了期限' }
  let(:button_name_regist) { '登録' }
  let(:button_name_edit) { '更新' }
  let(:task_list_dom) { all('.list_table tbody tr') }
  test_loop_num = 3
  # used_sequence_count = 0 # test使った後のシーケンス数カウント

  # index
  feature '一覧画面' do
    background do
      FactoryBot.rewind_sequences
    end

    # 一覧画面のテスト
    feature 'sort確認' do
      background do
        # n時間ずらしの生成日でタスク生成
        FactoryBot.create_list(:task_seq_created_at, test_loop_num)
      end
      context '作成日昇順（初期表示）' do
        scenario 'ソートされる' do
          visit tasks_path
          test_loop_num.times do |num|
            expect(task_list_dom[num]).to have_content "task#{num}"
          end
        end
      end
      context '作成日降順' do
        scenario 'ソートされる' do
          visit tasks_path(sort: 'created_at', order: 'desc')
          test_loop_num.times do |num|
            reverse_num = test_loop_num - num -1
            expect(task_list_dom[num]).to have_content "task#{reverse_num}"
          end
        end
      end
    end

    # index-sort
    feature '期限でソート' do
      background do
        # データ作成　期限日ずらしで生成
        FactoryBot.create_list(:task_seq_due_date, test_loop_num)
      end

      # テスト
      context '終了期限昇順' do
        scenario 'ソートされる' do
          visit tasks_path(sort: 'due_date', order: 'asc')
          test_loop_num.times do |num|
            expect(task_list_dom[num]).to have_content "task#{num }"
          end
        end
      end
      context '終了期限昇順' do
        scenario 'ソートされる' do
          visit tasks_path(sort: 'due_date', order: 'desc')
          test_loop_num.times do |num|
            reverse_num = test_loop_num - num -1
            expect(task_list_dom[num]).to have_content "task#{reverse_num}"
          end
        end
      end
    end
  end

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
        input_due_date = Time.current + 10.days

        # フィールドに入力
        fill_in label_name_task, with: input_name
        fill_in label_name_detail, with: input_description
        fill_in label_name_due_date, with: input_due_date

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
        fill_in label_name_due_date, with: nil
        # ボタンをクリック
        click_button button_name_regist
        # エラーメッセージが出ていることを確認
        expect(page).to have_content 'タスク名を入力してください'
      end
    end
    context 'description未記入の場合' do
      scenario 'タスクの新規作成が成功' do
        # 入力
        fill_in label_name_task, with: '電気の手続き'
        fill_in label_name_detail, with: nil
        fill_in label_name_due_date, with: nil
        # ボタンをクリック
        click_button button_name_regist
        # 完了メッセージが出ていることを確認
        expect(page).to have_content 'タスクを登録しました'
      end
    end
    context '入力閾値チェック' do
      context 'タスク名256オーバー' do
        scenario 'タスク登録失敗する' do
          # 入力
          fill_in label_name_task, with: SecureRandom.alphanumeric(257)
          fill_in label_name_detail, with: 'test'
          click_button button_name_regist
          # エラーメッセージが出ていることを確認
          expect(page).to have_content 'タスク名は256文字以内で入力してください'
        end
      end
      context '詳細1024オーバー' do
        scenario 'タスク登録失敗する' do
          # 入力
          fill_in label_name_task, with: 'test'
          fill_in label_name_detail, with: SecureRandom.alphanumeric(1025)
          click_button button_name_regist
          # エラーメッセージが出ていることを確認
          expect(page).to have_content '詳細は1024文字以内で入力してください'
        end
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
        # OKボタンを押す
        page.accept_confirm '削除しますか？'
        expect(page).to have_content 'タスクを削除しました。'
      end.to change { Task.count }.by(-1)
    end
  end
end
