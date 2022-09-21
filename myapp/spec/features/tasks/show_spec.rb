# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/:id' do
  feature '#show' do
    given(:task) do
      create(:task,
             id: 1,
             name: 'aqua',
             end_date:,
             priority: 'high',
             status: 'untouched',
             explanation: 'aqua hara')
    end
    given(:end_date) { '2022/09/14 17:25' }

    scenario 'correctly shows task' do
      visit task_path(task)

      expect(current_path).to eq '/tasks/1'
      expect(page).to have_content 'aqua'
      expect(page).to have_content end_date
      expect(page).to have_content '高'
      expect(page).to have_content '未着手'
      expect(page).to have_content 'aqua hara'
    end

    scenario 'renders #edit' do
      visit task_path(task)
      click_on '編集する'

      expect(current_path).to eq "/tasks/#{task.id}/edit"
      expect(page).to have_content 'タスク編集'
    end

    scenario 'renders #index' do
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
  end
end
