# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/:id/edit' do
  feature '#edit' do
    given(:task) { create(:task) }
    given(:user) { create(:user) }

    scenario 'renders #show' do
      login(user)

      visit edit_task_path(task)
      click_on '詳細を確認する'

      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content task.name.to_s
    end

    scenario 'renders #index' do
      login(user)

      visit edit_task_path(task)
      click_on '一覧に戻る'

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'correctly updates edit task' do
      login(user)

      visit edit_task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}/edit"

      fill_in 'タスク名', with: 'うぷだてタスクやで'
      fill_in '終了期限', with: Time.current.to_s
      select '普通', from: 'task[priority]'
      select '着手中', from: 'task[status]'
      fill_in '説明', with: 'update!!!!!タスク的な説明なやつ'

      expect { click_button '更新する' }.to \
        change { Task.exists?(name: 'うぷだてタスクやで') }.from(false).to(true)
      expect(current_path).to eq "/tasks/#{Task.last.id}"
      expect(page).to have_content 'タスクが正常に更新されました'
    end

    scenario 'does not update with empty name' do
      login(user)

      visit edit_task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}/edit"

      fill_in 'タスク名', with: ''
      fill_in '終了期限', with: Time.current.to_s
      select '高', from: 'task[priority]'
      select '未着手', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button '更新する' }.to change(Task, :count).by(0)
      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'タスク名を入力してください'
    end
  end
end
