require 'rails_helper'

RSpec.describe Task, js: true, type: :system do
    
  describe '新規登録機能' do
    context '全てのフォームの入力値が正常' do
      it 'タスクの新規作成が成功' do
        visit new_task_path
        fill_in 'task[title]', with: 'testtitle1'
        fill_in 'task[content]', with: 'testcontent1'
        click_button '登録'
        expect(current_path).to eq tasks_path
        expect(page).to have_content '登録が完了しました'
      end
    end
  end

  describe '編集機能' do

    let(:task) { create(:task) }

    context '全てのフォームの入力値が正常' do
      it 'タスクの編集が成功' do
        visit edit_task_path(task)
        fill_in 'task[title]', with: 'testtitle2'
        fill_in 'task[content]', with: 'testcontent2'
        click_button '登録'
        expect(current_path).to eq tasks_path
        expect(page).to have_content '更新が完了しました'
      end
    end
  end

  describe '削除機能' do

    let(:task) { create(:task) }

    it 'taskの投稿が削除される' do
      visit task_path(task)
      click_link '削除'
      expect(page.accept_confirm).to eq "本当に削除しますか？"
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクを削除しました'

    end
  end
end
