# frozen_string_literal: true

require 'rails_helper'

TD_IDX_TITLE = 0

RSpec.describe 'Tasks', type: :system do
  let(:user) { User.create(name: 'test', password: 'test') }

  describe 'Task list' do
    context 'When a task dose not exist' do
      before do
        visit tasks_path
      end
      it 'Check the message' do
        expect(page).to have_content(I18n.t('tasks.no_tasks'))
      end
    end

    context 'When a task exists' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit tasks_path
      end
      it 'Check the message and the content of the task' do
        expect(page).not_to have_content(I18n.t('tasks.no_tasks'))
        expect(page).to have_content('test1')
      end
    end

    TD_IDX_TITLE = 0
    context 'Check the order of tasks' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', updated_at: '2024-03-01', user_id: user.id)
        Task.create!(title: 'test2', description: 'desc2', due_date: '2024-03-01', updated_at: '2024-02-01', user_id: user.id)
        Task.create!(title: 'test3', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01', user_id: user.id)
      end

      it 'Default order (created_at desc)' do
        visit tasks_path
        within('table#result') do
          first_row = all('tr')[1]
          first_title = first_row.all('td')[TD_IDX_TITLE]
          expect(first_title.text).to eq('test3')

          second_row = all('tr')[2]
          second_title = second_row.all('td')[TD_IDX_TITLE]
          expect(second_title.text).to eq('test2')

          third_row = all('tr')[3]
          third_title = third_row.all('td')[TD_IDX_TITLE]
          expect(third_title.text).to eq('test1')
        end
      end

      it 'due_date asc' do
        visit tasks_path(sort: 'due_date', direction: 'asc')
        within('table#result') do
          first_row = all('tr')[1]
          first_title = first_row.all('td')[TD_IDX_TITLE]
          expect(first_title.text).to eq('test1')

          second_row = all('tr')[2]
          second_title = second_row.all('td')[TD_IDX_TITLE]
          expect(second_title.text).to eq('test3')

          third_row = all('tr')[3]
          third_title = third_row.all('td')[TD_IDX_TITLE]
          expect(third_title.text).to eq('test2')
        end
      end

      it 'update_date asc' do
        visit tasks_path(sort: 'updated_at', direction: 'asc')
        within('table#result') do
          first_row = all('tr')[1]
          first_title = first_row.all('td')[TD_IDX_TITLE]
          expect(first_title.text).to eq('test3')

          second_row = all('tr')[2]
          second_title = second_row.all('td')[TD_IDX_TITLE]
          expect(second_title.text).to eq('test2')

          third_row = all('tr')[3]
          third_title = third_row.all('td')[TD_IDX_TITLE]
          expect(third_title.text).to eq('test1')
        end
      end
    end

    context 'Search function' do
      before do
        Task.create!(title: 'title1', description: 'desc1', due_date: '2024-01-01', status: :open, user_id: user.id)
        Task.create!(title: 'title12', description: 'desc2', due_date: '2024-03-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-02-01', status: :open, user_id: user.id)
      end

      it 'When searching by title, if results are found' do
        visit tasks_path(title: 'title3')
        within('table#result') do
          row = all('tr')[1]
          title = row.all('td')[TD_IDX_TITLE]
          expect(title.text).to eq('title3')
        end
      end

      it 'When searching by title, if results are not found' do
        visit tasks_path(title: 'title4')
        within('table#result') do
          row = all('tr')[1]
          expect(row).to be_nil
        end
      end

      it 'When searching by status, if results are found' do
        visit tasks_path(status: :in_progress)
        within('table#result') do
          row = all('tr')[1]
          title = row.all('td')[TD_IDX_TITLE]
          expect(title.text).to eq('title12')
        end
      end

      it 'When searching by status, if results are not found' do
        visit tasks_path(status: :closed)
        within('table#result') do
          row = all('tr')[1]
          expect(row).to be_nil
        end
      end

      it 'When searching by title and status, if results are not found' do
        visit tasks_path(title: 'title1', status: :open)
        within('table#result') do
          row = all('tr')[1]
          title = row.all('td')[TD_IDX_TITLE]
          expect(title.text).to eq('title1')
        end
      end
    end
  end

  describe 'Screen transition' do
    context 'Display the new creation screen' do
      before do
        visit tasks_path
        click_button 'Create'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Create Task')
      end
    end

    context 'Display the updating screen' do
      before do
        task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit tasks_path
        click_button 'Update'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Edit Task')
      end
    end
  end

  describe 'Create a new task' do
    before do
      User.create(name: 'test', password: 'test')
      visit new_task_path
      fill_in 'task_title', with: 'title-new'
      fill_in 'task_description', with: 'desc-new'
      fill_in 'task_due_date', with: '2025-03-01'
      click_button 'Proceed'
    end
    it 'Check the type of screen and the content of the task' do
      expect(page).to have_content('Details')
      expect(page).to have_content('title-new')
      expect(page).to have_content('desc-new')
    end
  end

  describe 'Update a task' do
    before do
      task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: user.id)
      visit edit_task_path(task)
      fill_in 'task_title', with: 'title-modified'
      fill_in 'task_description', with: 'desc-modified'
      click_button 'Proceed'
    end

    it 'Check the type of screen and the content of the task' do
      expect(page).to have_content('Details')
      expect(page).to have_content('title-modified')
      expect(page).to have_content('desc-modified')
    end
  end

  describe 'Delete a task' do
    before do
<<<<<<< HEAD
      task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
=======
      Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
>>>>>>> shinya-uchiamki-step15
      visit tasks_path
    end

    it 'Ensure that the task to be deleted exists' do
      expect(page).to have_content('test1')
    end

    it 'Confirm that the task has been deleted' do
      click_button 'Delete'
      expect(page).not_to have_content('test1')
      expect(page).to have_content(I18n.t('tasks.no_tasks'))
    end
  end
end
