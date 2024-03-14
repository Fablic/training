require 'rails_helper'

def login
  visit '/login'
  fill_in 'session[username]', with: 'user'
  fill_in 'session[password]', with: 'test'
  click_on 'Login'
end

def create_user
  create(:user, username: 'user', password: 'test')
end

RSpec.describe 'Tasks', type: :system do

  describe 'page rendering' do
    before do
      create_user
      login
    end

    let!(:user) { create(:user) }

    it 'homepage should be the task list page' do
      visit '/'
      expect(page).to have_content 'Tasks'
    end

    it 'task list page should be shown' do
      create(:task, name: "test_task" , user: user)
      visit '/tasks'
      expect(page).to have_content 'Tasks'
    end

    it 'task detail page should be shown' do
      task = create(:task, user: user)
      visit "/tasks/#{task.id}"
      expect(page).to have_content "#{task.name}"
    end

    it 'task edit page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}/edit"
      expect(page).to have_content 'Edit task'
    end

    it 'task create page should be shown' do
      visit '/tasks/new'
      expect(page).to have_content 'Input New task'
    end
  end

  describe 'task creation' do
    before do
      create_user
      login
    end  
    it 'task created successfully & show flash message when task created', :aggregate_failure do
      visit '/'
      click_link('New task')
      fill_in 'task[name]', with: 'a_new_task'
      fill_in 'task[description]', with: 'new task description'
      select 'Done', from: 'Status'
      select 'Low', from: 'Priority'
      fill_in 'task[duedate]', with: '2024-08-08'
      click_on "Update"
      expect(page).to have_content "a_new_task"
      expect(page).to have_link href: /\/tasks\/\d+/
      expect(Task.last.name).to eq 'a_new_task'
    end
  end
  
  describe 'task update' do
    before do
      user = create_user
      create(:task, name: "task_before_edit", description: "description before", user: user)
      login
    end

    it 'task updated successfully' do
      visit '/'
      click_on('Edit')
      fill_in 'task[name]', with: 'task_after_edit'
      fill_in 'task[description]', with: 'description after'
      click_on "Update"
      expect(page).to have_content 'task_after_edit'
      expect(Task.last.name).to eq 'task_after_edit'
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
      expect(page).to have_content 'Task deleted successfully'
    end
  end
  
  describe 'pagination' do
    before do
      user = create_user
      login
      10.times do |i|
        create(:task, name: "Task#{i + 1}", priority: :Low, status: :Done, user: user)
      end
    end

    it 'show 5 tasks in the 1st page', :aggregate_failures do
      visit '/'
      5.times do |i|
        expect(page.body).to have_link "Task#{i + 1}"
      end
      5.times do |i|
        expect(page.body).not_to have_link "Task#{i + 6}"
      end
    end
  end

  describe 'show tasks list ordered by specific column in ascending/descending order' do
    before do
      user = create_user
      login
      create(:task, name: 'Task1', priority: 'High', status: 'Done', duedate: '2024-09-10',created_at: Time.now- 3.days, user: user)
      create(:task, name: 'Task2', priority: 'Low', status: 'In Progress' , duedate: '2024-09-23',created_at: Time.now- 2.days, user: user)
      create(:task, name: 'Task3', priority: 'Medium', status: 'Not Started', duedate: '2024-09-12', created_at: Time.now- 1.days, user: user)
    end

    it '3 tasks should be created' do
      visit '/'
    end

    it 'by created_time desc/asc' do
      visit '/'
      click_link('created_at')
      expect(page.body.index('Task3')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task1')
      click_link('created_at')
      expect(page.body.index('Task1')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task3')
    end 

    it 'by priority asc' do
      visit '/'
      click_link('Priority')
      expect(page.body.index('Task1')).to be < page.body.index('Task3')
      expect(page.body.index('Task3')).to be < page.body.index('Task2')
      click_link('Priority')
      expect(page.body.index('Task2')).to be < page.body.index('Task3')
      expect(page.body.index('Task3')).to be < page.body.index('Task1')
    end

    it 'by status asc' do
      visit '/'
      click_link('Status')
      expect(page.body.index('Task1')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task3')
      click_link('Status')
      expect(page.body.index('Task3')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task1')
    end

      it 'by duedate asc' do
        visit '/'
        click_link('Duedate')
        expect(page.body.index('Task1')).to be < page.body.index('Task3')
        expect(page.body.index('Task3')).to be < page.body.index('Task2')
        click_link('Duedate')
        expect(page.body.index('Task2')).to be < page.body.index('Task3')
        expect(page.body.index('Task3')).to be < page.body.index('Task1')
      end
  end

  it 'valid if task has all required contents' do
    task = create(:task)
    expect(task).to be_valid
  end

  it 'invalid if one or more required contents are missing' do
    task = Task.new(
      name: '',
      description: '',
      priority: '',
      status: '',
      duedate: '2024-08-08',
    )
    expect(task).to be_invalid
  end

  it 'valid if name length is 30' do
    task = build(:task, name: 'a' * 30)
    expect(task).to be_valid
  end

  it 'invalid if name is too long' do
    task = build(:task, name: 'a' * 31)
    expect(task).to be_invalid
  end

  it 'valid if description length is 255' do
    task = build(:task, description: 'a' * 255)
    expect(task).to be_valid
  end

  it 'invalid if description is too long' do
    task = build(:task, description: 'a' * 256)
    expect(task).to be_invalid
  end

  it 'valid if task duedate is future' do
    task = build(:task, duedate: Time.zone.tomorrow)
    expect(task).to be_valid
  end

  it 'invalid if task duedate is past' do
    task = build(:task, duedate: Date.today - 1)
    expect(task).to be_invalid
  end

  describe 'login/logout' do
    it 'login successfully' do
      create_user
      login
      expect(page.body).to have_content 'Tasks'
    end

    it 'login failed', :aggregate_failures do
      visit '/login'
      fill_in 'session[username]', with: 'wrong_user'
      fill_in 'session[password]', with: 'wrong_password'
      click_on 'Login'
      expect(page.body).to have_content 'Login'
      expect(page.body).to have_content 'Login failed!'
    end

    it 'cannot access task list page without login', :aggregate_failures do
      visit '/tasks'
      expect(page.body).to have_content 'Login'
    end

    it 'logout successfully', :aggregate_failures do
      create_user
      login
      expect(page.body).to have_content 'Tasks'
      click_button 'Logout'
      expect(page.body).to have_content 'Login'
    end
  end
end
