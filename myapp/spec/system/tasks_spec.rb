require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @user = create(:user)
    @task1 = create(:task, name: 'Task-1', status: 'Not Started')
    @task2 = create(:task, name: 'Task-2', status: 'In Progress')
    @task3 = create(:task, name: 'Task-3', status: 'Done')
  end

  describe 'Task list page' do
    it 'displays a list of tasks' do
      visit tasks_path
      # check that the tasks are in the list
      expect(page).to have_content('Task-1')
      expect(page).to have_content('Task-2')
      expect(page).to have_content('Task-3')
    end
  end

  describe 'Task creation' do
    it 'creates a new task with valid input' do
      visit new_task_path

      fill_in 'Name', with: 'New Task'
      select 'In Progress', from: 'Status'

      click_button 'Create Task'
      # check that the task was created
      expect(page).to have_content('Task was successfully created.')
      expect(page).to have_content('New Task')
      expect(page).to have_content('In Progress')

      click_link 'Back to Task List'
      # check that the task was created in the list
      expect(page).to have_content('New Task')
    end
  end

  describe 'Task update' do
    it 'updates a task with valid input' do
      visit edit_task_path(@task1)

      fill_in 'Name', with: 'Updated Task'
      select 'Done', from: 'Status'

      click_button 'Update Task'
      # check that the task was updated
      expect(page).to have_content('Task was successfully updated.')
      expect(page).to have_content('Updated Task')
      expect(page).to have_content('Done')

      click_link 'Back to Task List'
      # check that the task was updated in the list
      expect(page).to have_content('Updated Task')
      expect(page).not_to have_content('Task-1')
    end
  end

  describe 'Task deletion' do
    it 'deletes a task' do
      visit tasks_path

      expect(page).to have_content('Task-1')

      click_link 'Destroy', href: task_path(@task1)
      # check that the task was deleted
      expect(page).to have_content('Task was successfully deleted.')
      # check that the task is no longer in the list
      expect(page).not_to have_content('Task-1')
    end
  end
end
