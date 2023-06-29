# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  describe 'page rendering' do
    it 'homepage should be the task list page' do
      visit '/'
      expect(page).to have_content 'Tasks'
    end

    it 'task list page should be shown' do
      create(:task, name: 'test_task')
      visit '/tasks'
      expect(page).to have_content 'Tasks'
    end

    it 'tasks should be listed in the task list page' do
      create(:task, name: 'test_task')
      visit '/tasks'
      expect(page).to have_link 'test_task'
    end

    it 'task detail page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}"
      expect(page).to have_content 'Task detail'
    end

    it 'task edit page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}/edit"
      expect(page).to have_content 'Edit task'
    end

    it 'task create page should be shown' do
      visit '/tasks/new'
      expect(page).to have_content 'New task'
    end
  end

  describe 'task creation' do
    it 'task created successfully' do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: 'a_new_task'
      fill_in 'task[description]', with: 'new task description'
      select('Low', from: 'task[priority]')
      select('Todo', from: 'task[status]')
      click_on 'Create task'
      expect(page).to have_link 'a_new_task'
    end

    it 'show flash message when task created' do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: 'a_new_task'
      fill_in 'task[description]', with: 'new task description'
      select('Low', from: 'task[priority]')
      select('Todo', from: 'task[status]')
      click_on 'Create task'
      expect(page).to have_content 'Task was successfully created.'
    end

    it 'task failed to be created due to empty name' do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: ''
      fill_in 'task[description]', with: 'new task description'
      select('Low', from: 'task[priority]')
      select('Todo', from: 'task[status]')
      click_on 'Create task'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'task update' do
    before do
      create(:task, name: 'task_before_edit', description: 'description before')
    end

    it 'task name updated successfully' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      click_on 'Update task'
      expect(page).to have_link 'task_after_edit'
    end

    it 'task description updated successfully' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      fill_in 'task[description]', with: 'description after'
      click_on 'Update task'
      click_link('task_after_edit')
      expect(page).to have_content 'description after'
    end

    it 'show flash message when task updated' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      fill_in 'task[description]', with: 'description after'
      click_on 'Update task'
      expect(page).to have_content 'Task was successfully updated.'
    end

    it 'task failed to be updated due to empty name' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: ''
      click_on 'Update task'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'task deletion' do
    before do
      create(:task, name: 'task_should_be_deleted')
    end

    it 'task deleted successfully' do
      visit '/'
      click_on 'Delete'
      expect(page).not_to have_content 'task_should_be_deleted'
    end

    it 'show flash message when task deleted' do
      visit '/'
      click_on 'Delete'
      expect(page).to have_content 'Task was successfully destroyed.'
    end
  end

  describe 'show tasks list ordered by specific column in ascending/descending order' do
    before do
      create(:task, name: 'Task1', priority: 3, status: 2, expired_date: '2023-06-30')
      create(:task, name: 'Task2', priority: 1, status: 3, expired_date: '2024-06-30')
      create(:task, name: 'Task3', priority: 2, status: 1, expired_date: '2023-07-30')
    end

    it '3 tasks should be created' do
      visit '/'
      expect(Task.all.length).to eq 3
    end

    it 'by created_time asc' do
      visit '/'
      click_link('Sort by Created At ASC')
      expect(page.body).to match(/Task1.*Task2.*Task3.*/m)
    end

    it 'by created_time desc' do
      visit '/'
      click_link('Sort by Created At DESC')
      expect(page.body).to match(/Task3.*Task2.*Task1/m)
    end

    it 'by priority asc' do
      visit '/?sort_direction=ASC&sort_column=priority'
      expect(page.body).to match(/Task2.*Task3.*Task1/m)
    end

    it 'by priority desc' do
      visit '/?sort_direction=DESC&sort_column=priority'
      expect(page.body).to match(/Task1.*Task3.*Task2/m)
    end

    it 'by status asc' do
      visit '/?sort_direction=ASC&sort_column=status'
      expect(page.body).to match(/Task3.*Task1.*Task2/m)
    end

    it 'by status desc' do
      visit '/?sort_direction=DESC&sort_column=status'
      expect(page.body).to match(/Task2.*Task1.*Task3/m)
    end

    it 'by expired date asc' do
      visit '/?sort_direction=ASC&sort_column=expired_date'
      expect(page.body).to match(/Task1.*Task3.*Task2/m)
    end

    it 'by expired date desc' do
      visit '/?sort_direction=DESC&sort_column=expired_date'
      expect(page.body).to match(/Task2.*Task3.*Task1/m)
    end
  end

  describe 'show tasks list with default order if params are not valid' do
    before do
      create(:task, name: 'Task1', priority: 3, status: 2)
      create(:task, name: 'Task2', priority: 1, status: 3)
      create(:task, name: 'Task3', priority: 2, status: 1)
    end

    it '3 tasks should be created' do
      visit '/'
      expect(Task.all.length).to eq 3
    end

    it 'invalid sort column' do
      visit '/?sort_direction=ASC&sort_column=invalid'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'invalid sort direction' do
      visit '/?sort_direction=xxx&sort_column=name'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'sort column missing' do
      visit '/?sort_direction=ASC'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'sort direction missing' do
      visit '/?sort_column=name'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end
  end
end
