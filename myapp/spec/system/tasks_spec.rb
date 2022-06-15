require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:normal_user) { create(:normal_user) }
  let!(:task) { create(:task, user: normal_user) }
  let!(:label) { create(:label, user_id: normal_user.id) }
  let!(:other_label) { create(:label, user_id: normal_user.id) }

  let!(:other_user) { create(:other_user) }
  let!(:other_user_task) { create(:task, user: other_user) }

  before do
    visit login_path
    fill_in 'session_email', with: normal_user.email
    fill_in 'session_password', with: normal_user.password
    click_button 'ログイン'
  end

  describe 'サイドバー' do
    context 'タスク一覧をクリックした時' do
      before { visit new_task_path }
      it '一覧ページに正常に遷移できること' do
        find('#sidebar-index-link').click
        expect(current_path).to eq tasks_path
      end
    end

    context '新規作成リンクをクリックした時' do
      before { visit tasks_path }
      it 'タスク新規作成画面に正常に遷移できること' do
        find('#sidebar-new-link').click
        expect(current_path).to eq new_task_path
      end
    end
  end

  describe '一覧ページ' do
    describe '一覧表示機能' do
      let!(:task_list) { create_list(:task, 4, user: normal_user) }
      let!(:tasks_order_by_created_at_desc) { Task.where(user_id: normal_user.id).order(created_at: :desc) }
      let!(:first_task) { tasks_order_by_created_at_desc[0] }

      before { visit tasks_path }
      context 'アクセスしたとき' do
        it '画面が正常に表示されること' do
          expect(page).to have_content task.description
        end

        it '作成日時の降順でタスクが並んでいること' do
          expect(page.text).to match(/#{ tasks_order_by_created_at_desc[0].title }.*#{ tasks_order_by_created_at_desc[1].title }.*#{ tasks_order_by_created_at_desc[2].title }/)
        end

        it 'ログインユーザーのタスクのみ表示されていること' do
          expect(page).to have_no_content other_user_task.description
        end
      end

      context '終了期限の並び替えが1回押された時' do
        let!(:tasks_order_by_due_date_asc) { Task.where(user_id: normal_user.id).order(due_date: :asc) }
        it '終了期限の昇順にタスクが並んでいること' do
          click_on '終了期限'
          expect(page.text).to match(/#{ tasks_order_by_due_date_asc[0].title }.*#{ tasks_order_by_due_date_asc[1].title }.*#{ tasks_order_by_due_date_asc[2].title }/)
        end
      end

      context '終了期限の並び替えが2回押された時' do
        let!(:tasks_order_by_due_date_desc) { Task.where(user_id: normal_user.id).order(due_date: :desc) }
        it '終了期限の降順にタスクが並んでいること' do
          click_on '終了期限'
          click_on '終了期限'
          expect(page.text).to match(/#{ tasks_order_by_due_date_desc[0].title }.*#{ tasks_order_by_due_date_desc[1].title }.*#{ tasks_order_by_due_date_desc[2].title }/)
        end
      end

      context '新規作成ボタンが押された時' do
        it '正常に遷移すること' do
          find('#task-add-btn').click
          expect(current_path).to eq new_task_path
        end
      end

      context '編集ボタンが押された時' do
        it '正常に遷移すること' do
          all('table tr')[1].click_on '編集'
          expect(current_path).to eq edit_task_path first_task.id
        end
      end

      context '削除ボタンが押された時' do
        it '削除が正常に行われること' do
          all('table tr')[1].click_on '削除'
          expect(page).to have_no_content first_task.description
        end
      end

      context '詳細ボタンが押された時' do
        it '正常に遷移すること' do
          all('table tr')[1].click_on '詳細'
          expect(current_path).to eq task_path first_task.id
        end
      end

      context '他のユーザーのタスクのIDでリクエストが送られた時' do
        it '削除が行われずに、一覧画面にリダイレクトされること' do
          delete task_path other_user_task
          expect(Task.where(id: other_user_task.id)).to exist
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe '検索機能' do
      before { visit tasks_path }

      let!(:task_not_started) { create(:task, status: 0, title: 'target', user: normal_user) }
      let!(:task_in_progress) { create(:task, status: 1, description: 'target description', user: normal_user) }
      let!(:task_completed)   { create(:task, status: 2, user: normal_user) }

      context '文字列でのみ検索' do
        it '正常に動作していること' do
          find('#search_text').set(task_not_started.title)
          click_on '検索'
          expect(page).to have_content task_not_started.description
          expect(page).to have_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end

      context '状態でのみ検索' do
        it '正常に動作していること' do
          find('#search_status').find("option[value='0']").select_option
          click_on '検索'
          expect(page).to have_content task_not_started.description
          expect(page).to have_no_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end

      context 'ラベルでのみ検索' do
        it '正常に動作していること' do
          task_not_started.labels << label 
          find('#search_label').find("option[value=#{label.id}]").select_option
          click_on '検索'
          expect(page).to have_content task_not_started.description
          expect(page).to have_no_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end
      
      context '文字列を入力&未着手のステータスを選択して検索した時' do
        it 'タイトル&状態での検索が正常に動作していること' do
          find('#search_text').set(task_not_started.title)
          find('#search_status').find("option[value='0']").select_option
          click_on '検索'
          expect(page).to have_content task_not_started.description
          expect(page).to have_no_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end

      context '文字列を入力&実行中のステータスを選択して検索した時' do
        it '説明&状態での検索が正常に動作していること' do
          find('#search_text').set(task_in_progress.description)
          find('#search_status').find("option[value='1']").select_option
          click_on '検索'
          expect(page).to have_no_content task_not_started.description
          expect(page).to have_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end

      context '文字列を入力&ステータスを選択&ラベルを選択' do
        it '説明&ステータス&ラベルでの検索が正常に動作していること' do
          find('#search_text').set(task_in_progress.description)
          find('#search_status').find("option[value='1']").select_option
          find('#search_label').find("option[value=#{other_label.id}]").select_option
          click_on '検索'
          expect(page).to have_no_content task_not_started.description
          expect(page).to have_no_content task_in_progress.description
          expect(page).to have_no_content task_completed.description
        end
      end
    end

    describe 'ページング機能' do
      let!(:add_tasks_for_paging) {create_list(:task, 8, user: normal_user)}
      before { visit tasks_path }

      context 'アクセス時' do
        it 'ページングのデフォルト表示の件数が正しいこと' do
          expect(all('tbody tr').size).to eq(5)
        end
      end

      context '次のページ、前のページをクリックしたとき' do
        it 'ページングが正常に機能していること' do
          click_on '次のページ', match: :first
          expect(all('tbody tr').size).to eq(4)
          click_on '前のページ', match: :first
          expect(all('tbody tr').size).to eq(5)
        end
      end

      context '最初、最後をクリックした時' do
        it 'ページングが正常に機能していること' do
          click_on '最後', match: :first
          expect(all('tbody tr').size).to eq(4)
          click_on '最初', match: :first
          expect(all('tbody tr').size).to eq(5)
        end
      end

      context 'ナンバリングをクリックした時' do
        it 'ページ移動が正常に行われること' do
          click_on '2', match: :first
          expect(all('tbody tr').size).to eq(4)
          click_on '1', match: :first
          expect(all('tbody tr').size).to eq(5)
        end
      end
    end
  end

  describe 'タスク新規作成ページ' do
    before { visit new_task_path }

    context 'タスク新規作成時' do
      it 'タスク新規追加が正常に行われること' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
        check 'task_label_ids_' + label.id.to_s
        fill_in 'task[due_date]', with: '2022/05/10'
        click_button '保存'
        expect(page).to have_content 'タスクを新規作成しました。'
      end
    end

    context '戻るボタンが押された時' do
      it '正常に遷移すること' do
        click_on '戻る'
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'タスク編集ページ' do
    before { visit edit_task_path task }

    context 'アクセスしたとき' do
      it '画面が正常に表示されること' do
        expect(page).to have_content 'タスク編集'
      end
    end

    context '更新した時' do
      it '正常に更新が行われること' do
        fill_in 'task[title]',       with: 'edit task'
        fill_in 'task[description]', with: 'edit description'
        check 'task_label_ids_' + other_label.id.to_s
        fill_in 'task[due_date]',    with: '2022/05/12'
        click_button '保存'
        expect(page).to have_content 'タスクの情報を更新しました。'
      end
    end

    context '他のユーザーのタスクにアクセスした時' do
      it 'アクセスできず、一覧画面にリダイレクトされること' do
        visit edit_task_path other_user_task
        expect(current_path).to eq tasks_path
      end
    end
  end
end
