require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  context 'when at the register page,' do
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

  context 'when at the edit page,' do
    let(:task) { FactoryBot.create(:task) }
    let(:params) {
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

    example 'a task can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:title]
      fill_in 'task[description]', with: params[:description]
      select params[:status], from: 'Status'
      select params[:priority], from: 'Priority'
      fill_in 'task[expires_at]', with: params[:expires_at]
      click_button 'Update Task'

      expect(page).to have_content 'Task was successfully updated.'
      expect(page).to have_content params[:title]
      expect(page).to have_content params[:description]
      expect(page).to have_content params[:status]
      expect(page).to have_content params[:priority]
      expect(page).to have_content params[:expires_at]
    end
  end

  context 'when deleting a task,' do
    let(:task) { FactoryBot.create(:task) }

    example 'a task can be deleted.' do
      visit task_path(task)
      click_link 'Destroy'
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
