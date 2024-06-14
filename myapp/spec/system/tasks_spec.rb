# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) {User.create(name: 'test', password: 'test')}

  describe 'Task list' do
    context 'When a task dose not exist' do
      before do
        visit tasks_path
      end
      it 'Check the message' do
        expect(page).to have_content('タスクがありません。')
      end
    end

    context 'When a task exists' do
      before do
        task1 = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
        task２ = Task.create!(title: 'test2', description: 'desc2', due_date: '2024-02-01')
        visit tasks_path
      end
      it 'Check the message and the content of the task' do
        expect(page).not_to have_content('タスクがありません。')
        expect(page).to have_content('test1')
        expect(page).to have_content('test2')
      end
    end
  end

  describe 'Screen transition' do
    context 'Display the new creation screen' do
      before do
        visit tasks_path
        click_link 'Create task'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Create Task')
      end
    end

    context 'Display the updating screen' do
      before do
        task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
        visit tasks_path
        click_link 'Edit'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Edit Task')
      end
    end
  end

  describe 'Create a new task' do
    before do
      visit new_task_path
      fill_in 'task_title', with: 'title-new'
      fill_in 'task_description', with: 'desc-new'
      fill_in 'task_due_date', with: '2025-03-01'
      click_button 'Create'
    end
    it 'Check the type of screen and the content of the task' do
      expect(page).to have_content('Details')
      expect(page).to have_content('title-new')
      expect(page).to have_content('desc-new')
    end
  end

  describe 'Update a task' do
    before do
      task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01')
      visit edit_task_path(task)
      fill_in 'task_title', with: 'title-modified'
      fill_in 'task_description', with: 'desc-modified'
      click_button 'Update'
    end

    it 'Check the type of screen and the content of the task' do
      expect(page).to have_content('Details')
      expect(page).to have_content('title-modified')
      expect(page).to have_content('desc-modified')
    end
  end

  describe 'Delete a task' do
    before do
      task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
      visit tasks_path
    end

    it 'Ensure that the task to be deleted exists' do
      expect(page).to have_content('test1')
    end

    it 'Confirm that the task has been deleted' do
      click_button 'Delete'
      expect(page).not_to have_content('test1')
      expect(page).to have_content('タスクがありません。')
    end
  end
end
