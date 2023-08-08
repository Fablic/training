require 'rails_helper'

RSpec.describe 'Task', type: :system do

  describe 'Task list page' do
    it 'displays a list of tasks' do

      task1 = create(:task, title: 'Test Task 1', status: 0)
      task2 = create(:task, title: 'Test Task 2', status: 1)
      task3 = create(:task, title: 'Test Task 3', status: 2)

      visit task_index_path

      # check that the tasks are in the list
      expect(page).to have_content(task1.title)
      expect(page).to have_content(task2.title)
      expect(page).to have_content(task3.title)
    end
  end

  describe 'New Task creation' do
    it 'creates a new task' do
      visit new_task_path

      fill_in 'Title', with: 'New Task 1'
      select 'Not started', from: 'Status'

      click_button 'Create'

      # check that the task was created
      expect(page).to have_content('Task created.')
      expect(page).to have_content('Add Task')
      expect(page).to have_content('Not started')

    end
  end

  describe 'Task update' do
    it 'updates a task with modified input' do

      task = create(:task, title: 'Test Task 1', status: 0)

      visit edit_task_path(task)

      fill_in 'Title', with: 'Updated Test Task 1'

      select 'Completed', from: 'Status'

      click_button 'Update'

      expect(page).to have_content('Task updated.')
      expect(page).to have_content('Updated Test Task 1')
      expect(page).to have_content('Completed')

      click_link 'All Tasks'

      expect(page).not_to have_content('Test Task 1')
    end
  end

  describe 'Task deletion' do
    it 'deletes a task' do

      task = create(:task, title: 'Test Task 1', status: 0)

      expect(page).to have_content(task.title)

      click_link 'Delete', href: task_path(task)

      expect(page).to have_content('Task deleted.')

      expect(page).not_to have_content(task.title)
    end
  end
end
