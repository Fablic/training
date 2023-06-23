require 'rails_helper'

RSpec.describe "Tasks", type: :system do

  describe 'page rendering' do
    it 'homepage should be the task list page' do
      visit '/'
      expect(page).to have_content 'Tasks'
    end

    it 'task list page should be shown' do
      create(:task, name: "test_task")
      visit '/tasks'
      expect(page).to have_content 'Tasks'
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
      visit "/tasks/new"
      expect(page).to have_content 'New task'
    end
  end

  describe 'task creation' do
    it 'task created successfully' do
      visit '/'
      click_link('New task')
      expect(Task.all.length).to eq 0
      fill_in 'task[name]', with: 'a_new_task'
      fill_in 'task[description]', with: 'new task description'
      fill_in 'task[priority]', with: '1'
      fill_in 'task[status]', with: '1'
      click_on "Create task"
      expect(page).to have_content 'Task was successfully created.'
      expect(page).to have_link 'a_new_task'
      expect(Task.all.length).to eq 1
    end
  end

  describe 'task update' do
    before do
      create(:task, name: "task_before_edit", description: "description before")
    end

    it 'task updated successfully' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      fill_in 'task[description]', with: 'description after'
      click_on "Update task"
      expect(page).to have_content 'Task was successfully updated.'
      expect(page).to have_link 'task_after_edit'
      click_link('task_after_edit')
      expect(page).to have_content 'description after'
      expect(Task.all.length).to eq 1
    end
  end

  describe 'task deletion' do
    before do
      create(:task, name: "task_should_be_deleted")
    end

    it 'task deleted successfully' do
      visit '/'
      expect(Task.all.length).to eq 1
      expect(page).to have_content 'task_should_be_deleted'
      click_on "Delete"
      expect(page).to have_content 'Task was successfully destroyed.'
      expect(page).not_to have_content 'task_should_be_deleted'
      expect(Task.all.length).to eq 0
    end
  end

  describe 'show tasks list ordered by specific column in ascending/descending order' do
    before do
      create(:task, name: "Task1", priority: 3, status: 2)
      create(:task, name: "Task2", priority: 1, status: 3)
      create(:task, name: "Task3", priority: 2, status: 1)
    end

    it 'by created_time asc' do
      visit '/'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      click_link('Sort by Created At ASC')
      expect(page.body).to match /Task1.*Task2.*Task3.*/m
      expect(Task.all.length).to eq 3
    end

    it 'by created_time desc' do
      visit '/'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      click_link('Sort by Created At DESC')
      expect(page.body).to match /Task3.*Task2.*Task1/m
      expect(Task.all.length).to eq 3
    end

    it 'by priority asc' do
      visit '/?sort_direction=ASC&sort_column=priority'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task2.*Task3.*Task1/m
      expect(Task.all.length).to eq 3
    end

    it 'by priority desc' do
      visit '/?sort_direction=DESC&sort_column=priority'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task1.*Task3.*Task2/m
      expect(Task.all.length).to eq 3
    end

    it 'by status asc' do
      visit '/?sort_direction=ASC&sort_column=status'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task3'
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page.body).to match /Task3.*Task1.*Task2/m
      expect(Task.all.length).to eq 3
    end

    it 'by status desc' do
      visit '/?sort_direction=DESC&sort_column=status'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task3'
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page.body).to match /Task2.*Task1.*Task3/m
      expect(Task.all.length).to eq 3
    end
  end

  describe 'show tasks list with default order if params are not valid' do
    before do
      create(:task, name: "Task1", priority: 3, status: 2)
      create(:task, name: "Task2", priority: 1, status: 3)
      create(:task, name: "Task3", priority: 2, status: 1)
    end

    it 'invalid sort column' do
      visit '/?sort_direction=ASC&sort_column=invalid'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task1.*Task2.*Task3/m
    end

    it 'invalid sort direction' do
      visit '/?sort_direction=xxx&sort_column=name'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task1.*Task2.*Task3/m
    end

    it 'sort column missing' do
      visit '/?sort_direction=ASC'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task1.*Task2.*Task3/m
    end

    it 'sort direction missing' do
      visit '/?sort_column=name'
      expect(Task.all.length).to eq 3
      expect(page).to have_content 'Task1'
      expect(page).to have_content 'Task2'
      expect(page).to have_content 'Task3'
      expect(page.body).to match /Task1.*Task2.*Task3/m
    end
  end
end
