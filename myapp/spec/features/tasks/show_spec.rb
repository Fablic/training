# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/:id' do
  feature '#show' do
    let(:task) { create(:task) }

    scenario 'correctly shows task' do
      visit task_path(task)

      expect(current_path).to eq "/tasks/#{task.id}"
      expect(page).to have_content task.name.to_s
      expect(page).to have_content time_zone(task.end_date).to_s
      expect(page).to have_content task.priority.to_s
      expect(page).to have_content task.status.to_s
      expect(page).to have_content task.explanation.to_s
    end

    scenario 'renders #edit' do
      visit task_path(task)
      click_on I18n.t('transition_destination.edit')

      expect(current_path).to eq "/tasks/#{task.id}/edit"
      expect(page).to have_content 'タスク編集'
    end

    scenario 'renders #index' do
      visit task_path(task)
      click_on I18n.t('transition_destination.index')

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'correctly deletes task' do
      visit task_path(task)

      expect { click_on I18n.t('transition_destination.destroy') }.to change(Task, :count).by(-1)
      expect(current_path).to eq '/tasks'
      expect(page).to have_content I18n.t('crud_messages.destroy', model_name: I18n.t('activerecord.models.task'))
    end
  end
end
