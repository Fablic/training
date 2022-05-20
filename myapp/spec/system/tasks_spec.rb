require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task) { create(:task) }

  describe '一覧ページ' do
    let!(:task_list) { create_list(:task, 4) }
    let!(:tasks_order_by_created_at_desc) { Task.order(created_at: :desc) }
    let!(:first_task) { tasks_order_by_created_at_desc[0] }

    before { visit tasks_path }

    context 'アクセスしたとき' do
      it '画面が正常に表示されること' do
        expect(page).to have_content task.description
      end

      it '作成日時の降順でタスクが並んでいること' do
        expect(page.text).to match(/#{ tasks_order_by_created_at_desc[0].title }.*#{ tasks_order_by_created_at_desc[1].title }.*#{ tasks_order_by_created_at_desc[2].title }/)
      end
    end

    context '終了期限の並び替えが1回押された時' do
      let!(:tasks_order_by_due_date_asc) { Task.order(due_date: :asc) }
      it '終了期限の昇順にタスクが並んでいること' do
        click_on '終了期限'
        expect(page.text).to match(/#{ tasks_order_by_due_date_asc[0].title }.*#{ tasks_order_by_due_date_asc[1].title }.*#{ tasks_order_by_due_date_asc[2].title }/)
      end
    end

    context '終了期限の並び替えが2回押された時' do
      let!(:tasks_order_by_due_date_desc) { Task.order(due_date: :desc) }
      it '終了期限の降順にタスクが並んでいること' do
        click_on '終了期限'
        click_on '終了期限'
        expect(page.text).to match(/#{ tasks_order_by_due_date_desc[0].title }.*#{ tasks_order_by_due_date_desc[1].title }.*#{ tasks_order_by_due_date_desc[2].title }/)
      end
    end

    context '新規作成ボタンが押された時' do
      it '正常に遷移すること' do
        click_on 'タスク新規追加'
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
  end

  describe 'タスク新規作成ページ' do
    before { visit new_task_path }

    context 'タスク新規作成時' do
      it 'タスク新規追加が正常に行われること' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
        fill_in 'task[due_date]', with: '2022/05/10'
        click_button '新規作成'
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
        fill_in 'task[due_date]',    with: '2022/05/12'
        click_button '保存'
        expect(page).to have_content 'タスクの情報を更新しました。'
      end
    end
  end
end
