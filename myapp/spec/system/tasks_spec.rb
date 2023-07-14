# frozen_string_literal: true

require 'rails_helper'

def login
  visit '/login'
  fill_in 'session[name]', with: 'user'
  fill_in 'session[password]', with: '123'
  click_on 'Login'
end

def create_user
  create(:user, name: 'user', password: '123')
end

RSpec.describe 'Tasks' do
  describe 'page rendering' do
    before do
      create_user
      login
    end

    let!(:user) { User.last }

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
      create(:task, name: 'test_task', user: user)
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
    before do
      create_user
      login
    end

    it 'task created successfully & show flash message when task created', :aggregate_failures do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: 'a_new_task'
      fill_in 'task[description]', with: 'new task description'
      select('low', from: 'task[priority]')
      select('todo', from: 'task[status]')
      click_on 'Create task'
      expect(page).to have_link 'a_new_task'
      expect(page).to have_content 'Task was successfully created.'
    end

    it 'task failed to be created due to empty name' do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: ''
      fill_in 'task[description]', with: 'new task description'
      select('low', from: 'task[priority]')
      select('todo', from: 'task[status]')
      click_on 'Create task'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'task update' do
    before do
      user = create_user
      create(:task, name: 'task_before_edit', description: 'description before', user: user)
      login
    end

    it 'task name updated successfully from task lists page', :aggregate_failures do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      click_on 'Update task'
      expect(page).to have_content 'task_after_edit'
      expect(page).to have_content 'Task was successfully updated.'
    end

    it 'task name updated successfully from task details page', :aggregate_failures do
      visit '/'
      click_link('task_before_edit')
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      click_on 'Update task'
      expect(page).to have_content 'task_after_edit'
      expect(page).to have_content 'Task was successfully updated.'
    end

    it 'task description updated successfully', :aggregate_failures do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      fill_in 'task[description]', with: 'description after'
      click_on 'Update task'
      expect(page).to have_content 'description after'
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
      user = create_user
      create(:task, name: 'task_should_be_deleted', user: user)
      login
    end

    it 'task deleted successfully & show flash message when task deleted', :aggregate_failures do
      visit '/'
      click_on 'Delete'
      expect(page).not_to have_content 'task_should_be_deleted'
      expect(page).to have_content 'Task was successfully destroyed.'
    end
  end

  describe 'show tasks list ordered by specific column in ascending/descending order' do
    before do
      user = create_user
      login
      create(:task, name: 'Task1', priority: :high, status: :doing, expired_date: '2023-06-30', user: user)
      create(:task, name: 'Task2', priority: :low, status: :done, expired_date: '2024-06-30', user: user)
      create(:task, name: 'Task3', priority: :medium, status: :todo, expired_date: '2023-07-30', user: user)
    end

    it '3 tasks should be created' do
      visit '/'
      expect(Task.all.length).to eq 3
    end

    it 'by created_time asc' do
      visit '/'
      select('created_at', from: 'search[column]')
      select('ASC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task1.*Task2.*Task3.*/m)
    end

    it 'by created_time desc' do
      visit '/'
      select('created_at', from: 'search[column]')
      select('DESC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task3.*Task2.*Task1/m)
    end

    it 'by priority asc' do
      visit '/'
      select('priority', from: 'search[column]')
      select('ASC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task2.*Task3.*Task1/m)
    end

    it 'by priority desc' do
      visit '/'
      select('priority', from: 'search[column]')
      select('DESC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task1.*Task3.*Task2/m)
    end

    it 'by status asc' do
      visit '/'
      select('status', from: 'search[column]')
      select('ASC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task3.*Task1.*Task2/m)
    end

    it 'by status desc' do
      visit '/'
      select('status', from: 'search[column]')
      select('DESC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task2.*Task1.*Task3/m)
    end

    it 'by expired date asc' do
      visit '/'
      select('expired_date', from: 'search[column]')
      select('ASC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task1.*Task3.*Task2/m)
    end

    it 'by expired date desc' do
      visit '/'
      select('expired_date', from: 'search[column]')
      select('DESC', from: 'search[direction]')
      click_on 'Search'
      expect(page.body).to match(/Task2.*Task3.*Task1/m)
    end
  end

  describe 'show tasks list with default order if params are not valid' do
    before do
      user = create_user
      login
      create(:task, name: 'Task1', priority: :high, status: :doing, user: user)
      create(:task, name: 'Task2', priority: :low, status: :done, user: user)
      create(:task, name: 'Task3', priority: :medium, status: :todo, user: user)
    end

    it '3 tasks should be created' do
      visit '/'
      expect(Task.all.length).to eq 3
    end

    it 'search by name' do
      visit '/?task[direction]=ASC&task[column]=invalid'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'invalid sort direction' do
      visit '/?task[direction]=xxx&task[column]=name'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'sort column missing' do
      visit '/?task[direction]=ASC'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end

    it 'sort direction missing' do
      visit '/?task[column]=name'
      expect(page.body).to match(/Task1.*Task2.*Task3/m)
    end
  end

  describe 'get the correct tasks by search' do
    before do
      user = create_user
      login
      create(:task, name: 'Task1_y', priority: :high, status: :doing, user: user)
      create(:task, name: 'Task2_x', priority: :low, status: :done, user: user)
      create(:task, name: 'Task3', priority: :medium, status: :todo, user: user)
      create(:task, name: 'Task4_x', priority: :low, status: :todo, user: user)
      create(:task, name: 'Task5_y', priority: :low, status: :todo, user: user)
    end

    it '3 tasks should be created' do
      visit '/'
      expect(Task.all.length).to eq 5
    end

    it 'search by name', :aggregate_failures do
      visit '/'
      fill_in 'search[name]', with: '2'
      click_on 'Search'
      expect(page.body).to have_link 'Task2_x'
      expect(page.body).not_to have_content 'Task1'
      expect(page.body).not_to have_content 'Task3'
      expect(page.body).not_to have_content 'Task4'
      expect(page.body).not_to have_content 'Task5'
    end

    it 'search by status', :aggregate_failures do
      visit '/'
      select('doing', from: 'search[status]')
      click_on 'Search'
      expect(page.body).to have_link 'Task1_y'
      expect(page.body).not_to have_content 'Task2'
      expect(page.body).not_to have_content 'Task3'
      expect(page.body).not_to have_content 'Task4'
      expect(page.body).not_to have_content 'Task5'
    end

    it 'search by name & status', :aggregate_failures do
      visit '/'
      fill_in 'search[name]', with: 'x'
      select('todo', from: 'search[status]')
      click_on 'Search'
      expect(page.body).to have_link 'Task4_x'
      expect(page.body).not_to have_content 'Task1'
      expect(page.body).not_to have_content 'Task2'
      expect(page.body).not_to have_content 'Task3'
      expect(page.body).not_to have_content 'Task5'
    end
  end

  describe 'pagination' do
    before do
      user = create_user
      login
      20.times do |i|
        create(:task, name: "Task#{i + 1}", priority: :low, status: :todo, user: user)
      end
    end

    it 'show 10 tasks in the 1st page', :aggregate_failures do
      visit '/'
      10.times do |i|
        expect(page.body).to have_link "Task#{i + 1}"
      end
      10.times do |i|
        expect(page.body).not_to have_link "Task#{i + 11}"
      end
    end
  end

  describe 'login/logout' do
    it 'login successfully' do
      create_user
      login
      expect(page.body).to have_content 'Tasks'
    end

    it 'login failed', :aggregate_failures do
      visit '/login'
      fill_in 'session[name]', with: 'wrong_user'
      fill_in 'session[password]', with: 'wrong_password'
      click_on 'Login'
      expect(page.body).to have_content 'Login'
      expect(page.body).to have_content 'Login failed. Please input correct user name & password.'
    end

    it 'cannot access task list page without login', :aggregate_failures do
      visit '/tasks'
      expect(page.body).to have_content 'Login'
      expect(page.body).to have_content 'Please login first!'
    end

    it 'logout successfully', :aggregate_failures do
      create_user
      login
      expect(page.body).to have_content 'Tasks'
      click_button 'Log out'
      expect(page.body).to have_content 'Login'
    end
  end
end
