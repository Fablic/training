# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:admin) { User.create(name: 'admin', password: 'admin', role: 'admin') }
  let(:user) { User.create(name: 'user', password: 'user', role: 'standard') }
  let(:other) { User.create(name: 'other', password: 'other', role: 'standard') }

  before do
    visit session_path
    # pp page.html
    fill_in 'name', with: admin.name
    fill_in 'password', with: admin.password
    click_button 'commit'
  end

  describe 'list' do
    context 'When a task dose not exist' do
      before do
        visit admin_tasks_path
      end
      it 'Check the message' do
        expect(page).not_to have_content('test1')
      end
    end

    context 'When a task exists' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit admin_tasks_path
      end
      it 'Check the message and the content of the task' do
        expect(page).not_to have_content(I18n.t('tasks.no_tasks'))
        expect(page).to have_content('test1')
      end
    end

    context 'Check the order of tasks' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', updated_at: '2024-03-01', user_id: user.id)
        Task.create!(title: 'test2', description: 'desc2', due_date: '2024-03-01', updated_at: '2024-02-01', user_id: user.id)
        Task.create!(title: 'test3', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01', user_id: user.id)
      end

      it 'Default order (created_at desc)' do
        visit admin_tasks_path
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('test3')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('test2')
          expect(find('tr:nth-child(3) td:nth-child(1)').text).to eq('test1')
        end
      end
    end

    context 'Search function' do
      before do
        Task.create!(title: 'title1', description: 'desc1', due_date: '2024-01-01', status: :open, user_id: user.id)
        Task.create!(title: 'title12', description: 'desc2', due_date: '2024-03-01', status: :in_progress, user_id: other.id)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-02-01', status: :open, user_id: user.id)
      end

      it 'When searching by user_id, if results are found' do
        visit admin_tasks_path(user_id: other.id)
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title12')
        end
      end

      it 'When searching by user_id, if results are not found' do
        visit admin_tasks_path(user_id: admin.id)
        expect(page).not_to have_content('title1')
      end
    end
  end

  describe 'Screen transition' do
    context 'Display the details screen' do
      it 'Check the type of screen' do
        task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit admin_tasks_path
        click_link task.title
        expect(page).to have_content('Details')
      end
    end
    context 'Display the updating screen' do
      it 'Check the type of screen' do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit admin_tasks_path
        click_button 'update-1'
        expect(page).to have_content('Edit Task')
      end
    end
  end

  describe 'Update a task' do
    before do
      task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: user.id)
      visit edit_admin_task_path(task)
      fill_in 'task_title', with: 'title-modified'
      fill_in 'task_description', with: 'desc-modified'
      click_button 'proceed'
    end
    it 'Check the type of screen and the content of the task' do
      expect(page).to have_content('Details')
      expect(page).to have_content('title-modified')
      expect(page).to have_content('desc-modified')
    end
  end

  describe 'Delete a task' do
    before do
      Task.create!(title: 'title-user', description: 'desc-user', due_date: '2024-01-01', user_id: user.id)
      visit admin_tasks_path
    end

    it 'Ensure that the task to be deleted exists' do
      expect(page).to have_content('title-user')
    end

    it 'Confirm that the task has been deleted' do
      click_button 'delete-1'
      expect(page).not_to have_content('title-user')
    end
  end
end
