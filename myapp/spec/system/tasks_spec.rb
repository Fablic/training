# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe '#index' do
    let!(:tasks) { FactoryBot.create_list(:task, 2) }

    before {
      visit root_path()
    }

    example 'all tasks are displayed.' do
      expect(page).to have_content tasks.last.title
    end

    example 'one task can be shown.' do
      click_link tasks.first.title
      expect(page).to have_current_path task_path(tasks.first)
    end

    example 'a task can be deleted.' do
      expect {
        page.first('[data-method="delete"]').click
      }.to change(Task, :count).by(-1)
    end
  end

  describe '#new' do
    before do
      visit new_task_path()

      fill_in 'task[title]', with: 'spec test title'
      fill_in 'task[description]', with: 'spec test description'
      select 'low', from: 'Priority'
      fill_in 'task[expires_at]', with: '2021-11-19T10:58'

      click_button 'Create Task'
    end

    example 'A task can be registered.' do
      expect(page).to have_content 'Task was successfully created.'
    end
  end

  describe '#edit' do
    let!(:task) { FactoryBot.create(:task) }
    let!(:params) {
      {
        title: 'title for edit',
        description: 'description for edit',
        status: 'done',
        priority: 'high',
        expires_at: Time.zone.now,
      }
    }

    example 'the page can be shown.' do
      visit edit_task_path(task)
      expect(page).to have_field 'task[title]', with: task.title
    end

    example 'Title can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:title]
      click_button 'Update Task'

      expect(page).to have_content params[:title]
    end

    example 'Status can be updated.' do
      visit edit_task_path(task)
      select params[:status], from: 'Status'
      click_button 'Update Task'

      expect(page).to have_content params[:status]
    end

    example 'Priority can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:priority]
      click_button 'Update Task'

      expect(page).to have_content params[:priority]
    end

    example 'Expires_at can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:expires_at]
      click_button 'Update Task'

      expect(page).to have_content params[:expires_at]
    end
  end

  describe '#destroy' do
    let!(:task) { FactoryBot.create(:task) }

    example 'a task can be deleted.' do
      visit task_path(task)
      click_link 'Destroy'
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
