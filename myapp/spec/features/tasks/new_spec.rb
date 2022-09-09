# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/new' do
  feature '#new' do
    scenario 'correctly displays task new form' do
      visit new_task_path

      expect(current_path).to eq '/tasks/new'
    end

    scenario 'redirects to #index' do
      visit new_task_path
      click_on I18n.t('transition_destination.index')

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'creates new task' do
      visit new_task_path

      expect(current_path).to eq '/tasks/new'

      fill_in 'タスク名', with: 'タスク名ッダーン!!'
      fill_in '終了期限', with: Time.current.to_s
      select '低', from: 'task[priority]'
      select '完了', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button I18n.t('helpers.submit.create') }.to change(Task, :count).by(1)
      expect(Task.last.name).to eq 'タスク名ッダーン!!'
      expect(current_path).to eq "/tasks/#{Task.last.id}"
      expect(page).to have_content I18n.t('crud_messages.create', model_name: I18n.t('activerecord.models.task'))
    end

    scenario 'does not create no name task' do
      visit new_task_path

      expect(current_path).to eq '/tasks/new'

      fill_in 'タスク名', with: ''
      fill_in '終了期限', with: Time.current.to_s
      select '普通', from: 'task[priority]'
      select '着手中', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button I18n.t('helpers.submit.create') }.to change(Task, :count).by(0)
      expect(current_path).to eq '/tasks'
      expect(page).to have_content I18n.t('activerecord.errors.count_message', count: 1)
      expect(page).to have_content 'タスク名を入力してください'
    end
  end
end
