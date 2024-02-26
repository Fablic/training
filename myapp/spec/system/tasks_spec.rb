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
      expect(page).to have_content "#{task.name}"
    end

    it 'task edit page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}/edit"
      expect(page).to have_content 'Editing Task'
    end

    it 'task create page should be shown' do
      visit "/tasks/new"
      expect(page).to have_content 'Input New Task'
    end
  end

  describe 'task creation' do
    it 'task created successfully' do
        visit '/'
        click_link('New task')
        expect(Task.all.length).to eq 0
        fill_in 'task[name]', with: 'a_new_task'
        fill_in 'task[description]', with: 'new task description'
        fill_in 'task[priority]', with: 'Low'
        fill_in 'task[status]', with: 'Done'
        fill_in 'task[duedate]', with: '2024-08-08'
        click_on "Create task"
        expect(page).to have_content "a_new_task"
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
  end