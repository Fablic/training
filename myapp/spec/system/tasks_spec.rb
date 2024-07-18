# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:admin) { User.create(name: 'admin', password: 'admin', role: 'admin') }
  let(:user) { User.create(name: 'user', password: 'user', role: 'standard') }
  let(:other) { User.create(name: 'other', password: 'other', role: 'standard') }

  before do
    visit session_path
    # pp page.html
    fill_in 'name', with: user.name
    fill_in 'password', with: user.password
    click_button 'commit'
  end

  describe 'list' do
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

    context 'Check the order of tasks' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', updated_at: '2024-03-01', user_id: user.id)
        Task.create!(title: 'test2', description: 'desc2', due_date: '2024-03-01', updated_at: '2024-02-01', user_id: user.id)
        Task.create!(title: 'test3', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01', user_id: user.id)
      end

      it 'Default order (created_at desc)' do
        visit tasks_path
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('test3')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('test2')
          expect(find('tr:nth-child(3) td:nth-child(1)').text).to eq('test1')
        end
      end

      it 'due_date asc' do
        visit tasks_path(sort: 'due_date', direction: 'asc')
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('test1')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('test3')
          expect(find('tr:nth-child(3) td:nth-child(1)').text).to eq('test2')
        end
      end

      it 'update_date asc' do
        visit tasks_path(sort: 'updated_at', direction: 'asc')
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
        Task.create!(title: 'title12', description: 'desc2', due_date: '2024-03-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-02-01', status: :open, user_id: user.id)
      end

      it 'When searching by title, if results are found' do
        visit tasks_path(title: 'title3')
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title3')
        end
      end

      it 'When searching by title, if results are not found' do
        visit tasks_path(title: 'title4')
        expect(page).to have_content(I18n.t('tasks.no_tasks'))
      end

      it 'When searching by status, if results are found' do
        visit tasks_path(status: :in_progress)
        within('table#result') do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title12')
        end
      end

      it 'When searching by status, if results are not found' do
        visit tasks_path(status: :closed)
        expect(page).to have_content(I18n.t('tasks.no_tasks'))
      end

      it 'When searching by title and status, if results are found' do
        visit tasks_path(title: 'title1', status: :open)
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title1')
        end
      end
    end

    context 'Pagination' do
      before do
        Task.create!(title: 'title1', description: 'desc1', due_date: '2024-01-01', status: :open, user_id: user.id)
        Task.create!(title: 'title2', description: 'desc2', due_date: '2024-02-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-03-01', status: :closed, user_id: user.id)
        Task.create!(title: 'title4', description: 'desc4', due_date: '2024-04-01', status: :open, user_id: user.id)
        Task.create!(title: 'title5', description: 'desc5', due_date: '2024-05-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title6', description: 'desc6', due_date: '2024-06-01', status: :closed, user_id: user.id)
        Task.create!(title: 'title7', description: 'desc7', due_date: '2024-07-01', status: :open, user_id: user.id)
        Task.create!(title: 'title8', description: 'desc8', due_date: '2024-08-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title9', description: 'desc9', due_date: '2024-09-01', status: :closed, user_id: user.id)
        Task.create!(title: 'title10', description: 'desc10', due_date: '2024-10-01', status: :open, user_id: user.id)
        Task.create!(title: 'title11', description: 'desc11', due_date: '2024-11-01', status: :in_progress, user_id: user.id)
        Task.create!(title: 'title12', description: 'desc12', due_date: '2024-12-01', status: :closed, user_id: user.id)
        visit tasks_path
      end

      it 'first page ' do
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title12')
          expect(find('tr:nth-child(5) td:nth-child(1)').text).to eq('title8')
        end

        within 'ul.pagination' do
          #  first is link
          expect(page).to have_no_selector('li.page-item a.page-link', text: 'First')
          #  previous is link
          expect(page).to have_no_selector('li.page-item a.page-link', text: 'Previous')
          # page 1 is active
          expect(page).to have_selector('li.page-item.active a.page-link', text: '1')
          # page 2 is link
          expect(page).to have_selector('li.page-item a.page-link', text: '2')
          # page 3 is link
          expect(page).to have_selector('li.page-item a.page-link', text: '3')
          #  next is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Next')
          #  last is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Last')
        end
      end

      it 'second page ' do
        within 'ul.pagination' do
          click_link '2'
        end

        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title7')
          expect(find('tr:nth-child(5) td:nth-child(1)').text).to eq('title3')
        end

        within 'ul.pagination' do
          #  first is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'First')
          #  previous is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Previous')
          # page 1 is active
          expect(page).to have_selector('li.page-item a.page-link', text: '1')
          # page 2 is link
          expect(page).to have_selector('li.page-item.active a.page-link', text: '2')
          # page 3 is link
          expect(page).to have_selector('li.page-item a.page-link', text: '3')
          #  next is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Next')
          #  last is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Last')
        end
      end

      it 'third page ' do
        within 'ul.pagination' do
          click_link '3'
        end
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title2')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('title1')
        end
        within 'ul.pagination' do
          #  first is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'First')
          #  previous is link
          expect(page).to have_selector('li.page-item a.page-link', text: 'Previous')
          # page 1 is active
          expect(page).to have_selector('li.page-item a.page-link', text: '1')
          # page 2 is link
          expect(page).to have_selector('li.page-item a.page-link', text: '2')
          # page 3 is link
          expect(page).to have_selector('li.page-item.active a.page-link', text: '3')
          #  next is link
          expect(page).to have_no_selector('li.page-item a.page-link', text: 'Next')
          #  last is link
          expect(page).to have_no_selector('li.page-item a.page-link', text: 'Last')
        end
      end

      it 'Click First' do
        within 'ul.pagination' do
          click_link '2'
          click_link 'First'
        end
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title12')
          expect(find('tr:nth-child(5) td:nth-child(1)').text).to eq('title8')
        end
      end

      it 'Click Previous' do
        within 'ul.pagination' do
          click_link '2'
          click_link 'Previous'
        end
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title12')
          expect(find('tr:nth-child(5) td:nth-child(1)').text).to eq('title8')
        end
      end

      it 'Click Next' do
        within 'ul.pagination' do
          click_link '2'
          click_link 'Next'
        end
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title2')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('title1')
        end
      end

      it 'Click Last' do
        within 'ul.pagination' do
          click_link '2'
          click_link 'Last'
        end
        within 'table#result' do
          expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('title2')
          expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('title1')
        end
      end
    end
  end

  describe 'Screen transition' do
    context 'Display the new creation screen' do
      before do
        visit tasks_path
        click_button 'create'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Create Task')
      end
    end

    context 'Display the updating screen' do
      it 'Check the type of screen' do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit tasks_path
        click_button 'update-0'
        expect(page).to have_content('Edit Task')
      end

      it 'With permission' do
        task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: user.id)
        visit edit_task_path(task)
        expect(page).to have_content('Edit Task')
        expect(page).not_to have_content('Search')
      end

      it 'Without permission' do
        task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: other.id)
        visit edit_task_path(task)
        expect(page).not_to have_content('Edit Task')
        expect(page).to have_content('Search')
      end
    end

    context 'Display the details screen' do
      it 'Check the type of screen' do
        task = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', user_id: user.id)
        visit tasks_path
        click_link task.title
        expect(page).to have_content('Details')
      end

      it 'With permission' do
        task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: user.id)
        visit task_path(task)
        expect(page).to have_content('Details')
        expect(page).not_to have_content('Search')
      end

      it 'Without permission' do
        task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01', user_id: other.id)
        visit task_path(task)
        expect(page).not_to have_content('Details')
        expect(page).to have_content('Search')
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
      click_button 'proceed'
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
      visit tasks_path
    end

    it 'Ensure that the task to be deleted exists' do
      expect(page).to have_content('title-user')
      expect(page).not_to have_content('title-other')
    end

    it 'Confirm that the task has been deleted' do
      click_link 'delete-0'
      expect(page).not_to have_content('test1')
    end
  end
end
