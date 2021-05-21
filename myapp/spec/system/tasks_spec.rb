require 'rails_helper'

RSpec.describe TasksController, type: :system do
  describe 'Tasks page' do
    it 'lets a user show tasks' do
      task1 = create(:task, name: 'task1', description: 'Do TASK1!', due_date: 3.days.since, priority: :high, status: :doing)
      task2 = create(:task, name: 'task2', description: 'Do TASK2 if you have time.', priority: :low, status: :waiting)

      visit '/'

      expect(page).to have_text 'The list of tasks'
      expect(page).to have_link 'New', href: '/en/tasks/new'

      within_spec("Task##{task1.id}") do
        expect(page).to have_text 'task1'
        expect(page).to have_text 'Do TASK1!'
        expect(page).to have_text '3 days'
        expect(page).to have_text 'High'
        expect(page).to have_text 'Doing'
        expect(page).to have_link 'Edit', href: "/en/tasks/#{task1.id}/edit"
        expect(page).to have_link 'Delete', href: "/en/tasks/#{task1.id}"
      end

      within_spec("Task##{task2.id}") do
        expect(page).to have_text 'task2'
        expect(page).to have_text 'Do TASK2 if you have time.'
        expect(page).to have_text 'Low'
        expect(page).to have_text 'Waiting'
        expect(page).to have_link 'Edit', href: "/en/tasks/#{task2.id}/edit"
        expect(page).to have_link 'Delete', href: "/en/tasks/#{task2.id}"
      end
    end

    it 'lets a user filter tasks' do
      task1 = create(:task, name: 'Super cool task1', description: 'Do TASK1!', due_date: 3.days.since, priority: :high, status: :doing)
      task2 = create(:task, name: 'Super cool task2', description: 'Do TASK2 if you have time.', priority: :low, status: :done)
      task3 = create(:task, name: 'OK this is task3', description: 'Do TASK3 if you have time.', priority: :low, status: :done)

      visit '/'

      expect(page).to have_text 'The list of tasks'
      expect(page).to have_link 'New', href: '/en/tasks/new'

      expect(page).to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
      expect(page).to have_spec("Task##{task3.id}")

      # Filter with malicious value

      fill_in :name, with: '%' # If this value was not sanitized, all tasks will be shown.
      click_button 'Search'

      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).not_to have_spec("Task##{task2.id}")
      expect(page).not_to have_spec("Task##{task3.id}")

      # Filter with "cool"

      fill_in :name, with: 'cool'
      click_button 'Search'

      expect(page).to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
      expect(page).not_to have_spec("Task##{task3.id}")

      # Filter with "done"

      fill_in :name, with: ''
      select 'Done', from: 'status'
      click_button 'Search'

      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
      expect(page).to have_spec("Task##{task3.id}")

      # Filter with "cool" and "done"

      fill_in :name, with: 'cool'
      select 'Done', from: 'status'
      click_button 'Search'

      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
      expect(page).not_to have_spec("Task##{task3.id}")
    end

    it 'lets a user delete a task' do
      task = create(:task, name: 'to be deleted', description: 'DELETE!', priority: :normal, status: :waiting)

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Delete'
      end

      accept_alert 'Are you sure you want to delete the task?'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Succeeded to delete the task!'

      expect(page).not_to have_spec("Task##{task.id}")
    end
  end

  describe 'Task new page' do
    it 'lets a user create a new task' do
      visit '/'

      click_link 'New'
      expect(page).to have_current_path('/en/tasks/new')
      expect(page).to have_text 'Add a new task'

      fill_in 'Name', with: 'New Task: Foo'
      fill_in 'Description', with: 'This is a new task named Foo. Do what you want.'
      # HACK: Imitate the input. This varies based on browser configuration. It might be flaky.
      fill_in 'Due date', with: 40.days.since.strftime("%m%d%Y")
      select 'Low', from: 'Priority'
      select 'Waiting', from: 'Status'
      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Succeeded to add the task!'

      task = Task.find_by!(name: 'New Task: Foo')
      within_spec("Task##{task.id}") do
        expect(page).to have_text 'New Task: Foo'
        expect(page).to have_text 'This is a new task named Foo. Do what you want.'
        expect(page).to have_text '1 month'
        expect(page).to have_text 'Low'
        expect(page).to have_text 'Waiting'
        expect(page).to have_link 'Edit', href: "/en/tasks/#{task.id}/edit"
        expect(page).to have_link 'Delete', href: "/en/tasks/#{task.id}"
      end
    end

    it 'denies a request of creation with empty name and description' do
      visit '/'

      click_link 'New'
      expect(page).to have_current_path('/en/tasks/new')

      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Name must be filled in'
      expect(page).to have_text 'Description must be filled in'
      expect(Task.find_by(name: 'New Task: Foo')).to be_nil
    end
  end

  describe 'Task edit page' do
    it 'lets a user edit a task' do
      task = create(:task, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Edit'
      end

      expect(page).to have_current_path("/en/tasks/#{task.id}/edit")
      expect(page).to have_text 'Edit the task'

      fill_in 'Description', with: 'Updated description'
      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Succeeded to edit the task!'

      within_spec("Task##{task.id}") do
        expect(page).to have_text 'Updated description'
      end
    end

    it 'denies a request of update with empty name' do
      task = create(:task, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Edit'
      end

      fill_in 'Name', with: ''
      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Name must be filled in'

      within_spec("Task##{task.id}") do
        expect(page).to have_text 'to be edited'
      end
    end

    it 'denies a request of update with empty description' do
      task = create(:task, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Edit'
      end

      fill_in 'Description', with: ''
      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Description must be filled in'

      within_spec("Task##{task.id}") do
        expect(page).to have_text 'EDIT!'
      end
    end
  end
end
