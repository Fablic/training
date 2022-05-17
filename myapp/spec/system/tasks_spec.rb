require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task) { create(:task) }

  describe '#index' do
    before { visit tasks_path }

    context '一覧ページにアクセスしたとき' do
      it '画面が正常に表示されること' do
        expect(page).to have_content task.description
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
        click_on '編集'
        expect(current_path).to eq edit_task_path task.id
      end
    end

    context '削除ボタンが押された時' do
      it '削除が正常に行われること' do
        click_on '削除'
        expect(page).to have_no_content task.description
      end
    end
  end

  describe '#create' do
    before { visit new_task_path }

    context 'タスク新規作成時' do
      it 'タスク新規追加が正常に行われること' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
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

  describe '#edit' do
    before { visit edit_task_path task }

    context '編集ページにアクセスしたとき' do
      it '画面が正常に表示されること' do
        expect(page).to have_content 'タスク編集'
      end
    end

    context '更新した時' do
      it '正常に更新が行われること' do
        fill_in 'task[title]',       with: 'edit task'
        fill_in 'task[description]', with: 'edit description'
        click_button '保存'
        expect(page).to have_content 'タスクの情報を更新しました。'
      end
    end
  end
end
