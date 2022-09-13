# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/:id/edit' do
  feature '#edit' do
    let(:task) { create(:task) }

    scenario 'renders #show' do
      visit edit_task_path(task)
      click_on I18n.t('transition_destination.show')

      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content task.name.to_s
    end

    scenario 'renders #index' do
      visit edit_task_path(task)
      click_on I18n.t('transition_destination.index')

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'correctly updates edit task' do
      visit edit_task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}/edit"

      fill_in 'タスク名', with: 'うぷだてタスクやで'
      fill_in '終了期限', with: Time.current.to_s
      select '普通', from: 'task[priority]'
      select '着手中', from: 'task[status]'
      fill_in '説明', with: 'update!!!!!タスク的な説明なやつ'

      expect { click_button I18n.t('helpers.submit.update') }.to \
        change { Task.exists?(name: 'うぷだてタスクやで') }.from(false).to(true)
      expect(current_path).to eq "/tasks/#{Task.last.id}"
      expect(page).to have_content I18n.t('crud_messages.update', model_name: I18n.t('activerecord.models.task'))
    end

    scenario 'does not update with empty name' do
      visit edit_task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}/edit"

      fill_in 'タスク名', with: ''
      fill_in '終了期限', with: Time.current.to_s
      select '高', from: 'task[priority]'
      select '未着手', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button I18n.t('helpers.submit.update') }.to change(Task, :count).by(0)
      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content I18n.t('activerecord.errors.count_message', count: 1)
      expect(page).to have_content 'タスク名を入力してください'
    end
  end
end
