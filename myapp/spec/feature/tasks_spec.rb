require 'rails_helper'

RSpec.feature Task, type: :feature, js: true do
  let(:label_name_task) { 'タスク名' }
  let(:label_name_detail) { '詳細' }
  let(:label_name_status) { '状態' }
  let(:button_name_regist) { '登録' }
  let(:button_name_edit) { '更新' }
  let(:task_list_dom) { all('.task-list-table tbody tr') }
  test_loop_num = 3

  background do
    @test_user = FactoryBot.create(:user)
    valid_login(@test_user)
  end

  feature '一覧画面' do
    background do
      FactoryBot.rewind_sequences
    end

    feature 'sort確認' do
      background do
        FactoryBot.create_list(:task_seq_created_at, test_loop_num, user: @test_user)
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
          visit tasks_path(search_form: { sort: 'created_at', order: 'desc' })
          test_loop_num.times do |num|
            reverse_num = test_loop_num - num - 1
            expect(task_list_dom[num]).to have_content "task#{reverse_num}"
          end
        end
      end
    end

    # index-sort
    feature '期限でソート' do
      background do
        FactoryBot.create_list(:task_seq_due_date, test_loop_num, user: @test_user)
      end

      context '終了期限昇順' do
        scenario 'ソートされる' do
          visit tasks_path(search_form: { sort: 'due_date', order: 'asc' })
          test_loop_num.times do |num|
            expect(task_list_dom[num]).to have_content "task#{num}"
          end
        end
      end
      context '終了期限降順' do
        scenario 'ソートされる' do
          visit tasks_path(search_form: { sort: 'due_date', order: 'desc' })
          test_loop_num.times do |num|
            reverse_num = test_loop_num - num - 1
            expect(task_list_dom[num]).to have_content "task#{reverse_num}"
          end
        end
      end
    end
  end

  feature '新規登録画面' do
    background do
      visit new_task_path
    end
    context 'フォームの入力値が正常の場合' do
      scenario 'タスクの新規作成が成功' do
        input_name = 'ガス閉栓手続き'
        input_description = '京葉ガスに連絡・日付確定'

        fill_in label_name_task, with: input_name
        fill_in label_name_detail, with: input_description
        click_button button_name_regist
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content input_name
      end
    end

    context 'description未記入の場合' do
      scenario 'タスクの新規作成が成功' do
        # 入力
        fill_in label_name_task, with: '電気の手続き'
        fill_in label_name_detail, with: nil
        click_button button_name_regist
        expect(page).to have_content 'タスクを登録しました'
      end
    end
    context '入力閾値チェック' do
      context 'タスク名191オーバー' do
        scenario 'タスク登録失敗する' do
          fill_in label_name_task, with: SecureRandom.alphanumeric(192)
          fill_in label_name_detail, with: 'test'
          click_button button_name_regist
          expect(page).to have_content 'タスク名は191文字以内で入力してください'
        end
      end
      context '詳細1024オーバー' do
        scenario 'タスク登録失敗する' do
          fill_in label_name_task, with: 'test'
          fill_in label_name_detail, with: SecureRandom.alphanumeric(1025)
          click_button button_name_regist
          expect(page).to have_content '詳細は1024文字以内で入力してください'
        end
      end
    end
  end

  feature '更新画面' do
    scenario '成功する' do
      task1 = FactoryBot.create(:task, user: @test_user)
      input_new_task_name = 'タスク名更新'
      input_new_task_status = '完了'
      visit edit_task_path(id: task1.id)

      fill_in label_name_task, with: input_new_task_name
      select input_new_task_status, from: label_name_status
      click_button button_name_edit
      expect(page).to have_content 'タスクを更新しました'
      expect(page).to have_content input_new_task_name
    end
  end

  feature '一覧から削除実行' do
    background do
      FactoryBot.create(:task, user: @test_user)
      FactoryBot.create_list(:task_seq_created_at, test_loop_num, user: @test_user)
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
