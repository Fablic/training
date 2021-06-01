require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let(:user) { create(:user) }
  let(:labels) do
    {
      security: create(:label, name: 'security', user: user),
      bug: create(:label, name: 'bug', user: user),
      enhancement: create(:label, name: 'enhancement', user: user),
      special: create(:label, name: 'special', user: user),
    }
  end

  before do
    login_as user
  end

  describe 'Tasks page' do
    it 'lets a user show tasks' do
      task1 = create(:task, user: user, name: 'task1', description: 'Do TASK1!', due_date: 3.days.since, priority: :high, status: :doing).tap do |task|
        create(:task_label_attachment, task: task, label: labels[:security])
        create(:task_label_attachment, task: task, label: labels[:bug])
        create(:task_label_attachment, task: task, label: labels[:special])
      end
      task2 = create(:task, user: user, name: 'task2', description: 'Do TASK2 if you have time.', priority: :low, status: :waiting).tap do |task|
        create(:task_label_attachment, task: task, label: labels[:bug])
        create(:task_label_attachment, task: task, label: labels[:enhancement])
      end

      visit '/'

      expect(page).to have_text 'The list of tasks'
      expect(page).to have_link 'New', href: '/en/tasks/new'

      within_spec("Task##{task1.id}") do
        expect(page).to have_text 'task1'
        expect(page).to have_text 'Do TASK1!'
        expect(page).to have_link 'bug', href: '/en?label=bug'
        expect(page).to have_link 'security', href: '/en?label=security'
        expect(page).to have_link 'special', href: '/en?label=special'
        expect(page).to have_text '3 days'
        expect(page).to have_text 'High'
        expect(page).to have_text 'Doing'
        expect(page).to have_link 'Edit', href: "/en/tasks/#{task1.id}/edit"
        expect(page).to have_link 'Delete', href: "/en/tasks/#{task1.id}"
      end

      within_spec("Task##{task2.id}") do
        expect(page).to have_text 'task2'
        expect(page).to have_text 'Do TASK2 if you have time.'
        expect(page).to have_link 'bug', href: '/en?label=bug'
        expect(page).to have_link 'enhancement', href: '/en?label=enhancement'
        expect(page).to have_text 'Low'
        expect(page).to have_text 'Waiting'
        expect(page).to have_link 'Edit', href: "/en/tasks/#{task2.id}/edit"
        expect(page).to have_link 'Delete', href: "/en/tasks/#{task2.id}"
      end
    end

    it 'lets a user filter tasks' do
      task1 = create(:task, user: user, name: 'Super cool task1', description: 'Do TASK1!', due_date: 3.days.since, priority: :high, status: :doing)
      task2 = create(:task, user: user, name: 'Super cool task2', description: 'Do TASK2 if you have time.', priority: :low, status: :done)
      task3 = create(:task, user: user, name: 'OK this is task3', description: 'Do TASK3 if you have time.', priority: :low, status: :done)

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

    it 'lets a user filter tasks with labels' do
      task1 = create(:task, user: user, name: 'Super cool task1').tap do |task|
        create(:task_label_attachment, task: task, label: labels[:security])
        create(:task_label_attachment, task: task, label: labels[:special])
      end
      task2 = create(:task, user: user, name: 'Necessary task2').tap do |task|
        create(:task_label_attachment, task: task, label: labels[:bug])
        create(:task_label_attachment, task: task, label: labels[:special])
      end

      visit '/'

      expect(page).to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")

      # Filter by clicking a label

      within_spec("Task##{task1.id}") do
        click_link 'security'
      end
      expect(page).to have_spec("Task##{task1.id}")
      expect(page).not_to have_spec("Task##{task2.id}")

      page.go_back

      within_spec("Task##{task2.id}") do
        click_link 'bug'
      end
      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")

      page.go_back

      within_spec("Task##{task1.id}") do
        click_link 'special'
      end
      expect(page).to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")

      page.go_back

      # Filter with label and name

      fill_in :name, with: 'Necessary'
      select 'special', from: 'label'
      click_button 'Search'

      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
    end

    it 'navigates a user to the next page' do
      tasks = create_list(:task, 11, user: user).sort_by!(&:id)

      visit '/'

      tasks[0...10].each do |task|
        expect(page).to have_spec("Task##{task.id}")
      end
      expect(page).not_to have_spec("Task##{tasks[10].id}")

      within_spec('tasks-pagination') do
        click_link 'Next ›'
      end

      tasks[0...10].each do |task|
        expect(page).not_to have_spec("Task##{task.id}")
      end
      expect(page).to have_spec("Task##{tasks[10].id}")
    end

    it 'navigates a user to the next page with filtered query' do
      tasks_abc = create_list(:task, 11, user: user, name: 'abc').sort_by!(&:id)
      tasks_xyz = create_list(:task, 11, user: user, name: 'xyz').sort_by!(&:id)

      visit '/'

      fill_in :name, with: 'abc'
      click_button 'Search'

      tasks_abc[0...10].each do |task|
        expect(page).to have_spec("Task##{task.id}")
      end
      expect(page).not_to have_spec("Task##{tasks_abc[10].id}")

      within_spec('tasks-pagination') do
        click_link 'Next ›'
      end

      tasks_abc[0...10].each do |task|
        expect(page).not_to have_spec("Task##{task.id}")
      end
      expect(page).to have_spec("Task##{tasks_abc[10].id}")

      fill_in :name, with: 'xyz'
      click_button 'Search'

      tasks_xyz[0...10].each do |task|
        expect(page).to have_spec("Task##{task.id}")
      end
      expect(page).not_to have_spec("Task##{tasks_xyz[10].id}")

      within_spec('tasks-pagination') do
        click_link 'Next ›'
      end

      tasks_xyz[0...10].each do |task|
        expect(page).not_to have_spec("Task##{task.id}")
      end
      expect(page).to have_spec("Task##{tasks_xyz[10].id}")
    end

    it 'lets a user delete a task' do
      task = create(:task, user: user, name: 'to be deleted', description: 'DELETE!', priority: :normal, status: :waiting)

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Delete'
      end

      accept_alert 'Are you sure you want to delete the task?'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Succeeded to delete the task!'

      expect(page).not_to have_spec("Task##{task.id}")
    end

    it 'redirects the user without session' do
      logout

      visit '/'

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end

    it "cannot see another user's tasks" do
      user2 = create(:user)
      task1 = create(:task, user: user, name: 'task1', description: 'Do TASK1!', due_date: 3.days.since, priority: :high, status: :doing)
      task2 = create(:task, user: user, name: 'task2', description: 'Do TASK2 if you have time.', priority: :low, status: :waiting)
      task3 = create(:task, user: user2, name: 'task3', description: 'Do TASK3 if you have time.', priority: :low, status: :waiting)

      visit '/'

      expect(page).to have_spec("Task##{task1.id}")
      expect(page).to have_spec("Task##{task2.id}")
      expect(page).not_to have_spec("Task##{task3.id}")

      logout
      login_as user2

      expect(page).not_to have_spec("Task##{task1.id}")
      expect(page).not_to have_spec("Task##{task2.id}")
      expect(page).to have_spec("Task##{task3.id}")
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

    it 'lets a user create a new task with labels' do
      labels # Ensure the existence of labels owned by the user

      visit '/'

      click_link 'New'

      fill_in 'Name', with: 'New with labels'
      fill_in 'Description', with: 'New Task!'
      select 'security', from: 'Labels'
      select 'special', from: 'Labels'
      select 'bug', from: 'Labels'
      unselect 'security', from: 'Labels'
      click_button 'Submit'

      expect(page).to have_current_path('/en')
      expect(page).to have_text 'Succeeded to add the task!'

      task = Task.find_by!(name: 'New with labels')
      within_spec("Task##{task.id}") do
        expect(page).to have_text 'New with labels'
        expect(page).to have_text 'New Task!'
        expect(page).to have_link 'bug', href: '/en?label=bug'
        expect(page).to have_link 'special', href: '/en?label=special'
        expect(page).not_to have_link 'security'
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

    it 'redirects the user without session' do
      logout

      visit '/tasks/new'

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end
  end

  describe 'Task edit page' do
    it 'lets a user edit a task' do
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

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

    it 'lets a user edit a task to add a label' do
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting).tap do |task|
        create(:task_label_attachment, task: task, label: labels[:special])
      end

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Edit'
      end

      select 'bug', from: 'Labels'
      click_button 'Submit'

      within_spec("Task##{task.id}") do
        expect(page).to have_link 'special', href: '/en?label=special'
        expect(page).to have_link 'bug', href: '/en?label=bug'
      end
    end

    it 'lets a user edit a task to remove a label' do
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting).tap do |task|
        create(:task_label_attachment, task: task, label: labels[:special])
      end

      visit '/'

      within_spec("Task##{task.id}") do
        click_link 'Edit'
      end

      unselect 'security', from: 'Labels'
      click_button 'Submit'

      within_spec("Task##{task.id}") do
        expect(page).not_to have_link 'security'
      end
    end

    it 'denies a request of update with empty name' do
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

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
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

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

    it 'redirects the user without session' do
      task = create(:task, user: user, name: 'to be edited', description: 'EDIT!', priority: :normal, status: :waiting)

      visit "/en/tasks/#{task.id}/edit"
      expect(page).to have_current_path("/en/tasks/#{task.id}/edit")

      logout

      visit "/en/tasks/#{task.id}/edit"

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end
  end
end
