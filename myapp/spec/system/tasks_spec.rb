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
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
        visit tasks_path
      end
      it 'Check the message and the content of the task' do
        expect(page).not_to have_content(I18n.t('tasks.no_tasks'))
        expect(page).to have_content('test1')
      end
    end

    context 'Check the order of tasks' do
      before do
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', updated_at: '2024-03-01')
        Task.create!(title: 'test2', description: 'desc2', due_date: '2024-03-01', updated_at: '2024-02-01')
        Task.create!(title: 'test3', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01')
      end

      it 'Default order (created_at desc)' do
        visit tasks_path
        within('table#result') do
          expect_title(1, 'test3')
          expect_title(2, 'test2')
          expect_title(3, 'test1')
        end
      end

      it 'due_date asc' do
        visit tasks_path(sort: 'due_date', direction: 'asc')
        within('table#result') do
          expect_title(1, 'test1')
          expect_title(2, 'test3')
          expect_title(3, 'test2')
        end
      end

      it 'update_date asc' do
        visit tasks_path(sort: 'updated_at', direction: 'asc')
        within('table#result') do
          expect_title(1, 'test3')
          expect_title(2, 'test2')
          expect_title(3, 'test1')
        end
      end
    end

    context 'Search function' do
      before do
        Task.create!(title: 'title1', description: 'desc1', due_date: '2024-01-01', status: :open)
        Task.create!(title: 'title12', description: 'desc2', due_date: '2024-03-01', status: :in_progress)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-02-01', status: :open)
      end

      it 'When searching by title, if results are found' do
        visit tasks_path(title: 'title3')
        within('table#result') do
          expect_title(1, 'title3')
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
          expect_title(1, 'title12')
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
        within 'table#result' do
          expect_title(1, 'title1')
        end
      end
    end

    context 'Pagination' do
      before do
        Task.create!(title: 'title1', description: 'desc1', due_date: '2024-01-01', status: :open)
        Task.create!(title: 'title2', description: 'desc2', due_date: '2024-02-01', status: :in_progress)
        Task.create!(title: 'title3', description: 'desc3', due_date: '2024-03-01', status: :closed)
        Task.create!(title: 'title4', description: 'desc4', due_date: '2024-04-01', status: :open)
        Task.create!(title: 'title5', description: 'desc5', due_date: '2024-05-01', status: :in_progress)
        Task.create!(title: 'title6', description: 'desc6', due_date: '2024-06-01', status: :closed)
        Task.create!(title: 'title7', description: 'desc7', due_date: '2024-07-01', status: :open)
        Task.create!(title: 'title8', description: 'desc8', due_date: '2024-08-01', status: :in_progress)
        Task.create!(title: 'title9', description: 'desc9', due_date: '2024-09-01', status: :closed)
        Task.create!(title: 'title10', description: 'desc10', due_date: '2024-10-01', status: :open)
        Task.create!(title: 'title11', description: 'desc11', due_date: '2024-11-01', status: :in_progress)
        Task.create!(title: 'title12', description: 'desc12', due_date: '2024-12-01', status: :closed)
        visit tasks_path
      end

      it 'first page ' do
        within 'table#result' do
          expect_title(1, 'title12')
          expect_title(5, 'title8')
        end

        within 'nav' do
          expect(page).to have_selector('ul.pagination')
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
        within 'nav' do
          click_link '2'
        end

        within 'table#result' do
          expect_title(1, 'title7')
          expect_title(5, 'title3')
        end

        within 'nav' do
          expect(page).to have_selector('ul.pagination')
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
        within 'nav' do
          click_link '3'
        end
        within 'table#result' do
          expect_title(1, 'title2')
          expect_title(2, 'title1')
        end
        within 'nav' do
          expect(page).to have_selector('ul.pagination')
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
        within 'nav' do
          click_link '2'
          click_link 'First'
        end
        within 'table#result' do
          expect_title(1, 'title12')
          expect_title(5, 'title8')
        end
      end

      it 'Click Previous' do
        within 'nav' do
          click_link '2'
          click_link 'Previous'
        end
        within 'table#result' do
          expect_title(1, 'title12')
          expect_title(5, 'title8')
        end
      end

      it 'Click Next' do
        within 'nav' do
          click_link '2'
          click_link 'Next'
        end
        within 'table#result' do
          expect_title(1, 'title2')
          expect_title(2, 'title1')
        end
      end

      it 'Click Last' do
        within 'nav' do
          click_link '2'
          click_link 'Last'
        end
        within 'table#result' do
          expect_title(1, 'title2')
          expect_title(2, 'title1')
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
        Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
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
      task = Task.create!(title: 'title', description: 'desc', due_date: '2024-01-01')
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
      Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01')
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

  def expect_title(index, title)
    row = all('tr')[index]
    value = row.all('td')[TD_IDX_TITLE]
    expect(value.text).to eq(title)
  end
end
