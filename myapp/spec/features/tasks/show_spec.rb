# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/:id' do
  let!(:task) { create(:task) }

  feature '#show' do
    scenario 'redirects to #edit' do
      visit task_path(task)
      click_on '編集する'

      expect(current_path).to eq "/tasks/#{task.id}/edit"
      expect(page).to have_content 'タスク編集'
    end

    scenario 'redirects to #index' do
      visit task_path(task)
      click_on '一覧に戻る'

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'correctly deletes task' do
      visit task_path(task)

      expect { click_on '削除する' }.to change(Task, :count).by(-1)
      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスクが正常に削除されました'
    end

    scenario 'correctly shows task' do
      visit task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content task.name.to_s
      expect(page).to have_content time_zone(task.end_date).to_s
      expect(page).to have_content task_priority_enum_to_ja(task.priority)
      expect(page).to have_content task_status_enum_to_ja(task.status)
      expect(page).to have_content task.explanation.to_s
    end
  end
end
