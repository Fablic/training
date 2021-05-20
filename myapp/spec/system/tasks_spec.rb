require 'rails_helper'

RSpec.describe TasksController, type: :system do
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

  it 'lets a user create a new task' do
    visit '/'

    click_link 'New'
    expect(page).to have_current_path('/en/tasks/new')
    expect(page).to have_text 'Add a new task'

    fill_in 'Name', with: 'New Task: Foo'
    fill_in 'Description', with: 'This is a new task named Foo. Do what you want.'
    fill_in 'Due date', with: 3.days.since.strftime("%Y\t%m\t%d")
    select 'Low', from: 'Priority'
    select 'Waiting', from: 'Status'
    click_button 'Submit'

    expect(page).to have_current_path('/en')
    expect(page).to have_text 'Succeeded to add the task!'

    task = Task.find_by!(name: 'New Task: Foo')
    within_spec("Task##{task.id}") do
      expect(page).to have_text 'New Task: Foo'
      expect(page).to have_text 'This is a new task named Foo. Do what you want.'
      expect(page).to have_text 'Low'
      expect(page).to have_text 'Waiting'
      expect(page).to have_link 'Edit', href: "/en/tasks/#{task.id}/edit"
      expect(page).to have_link 'Delete', href: "/en/tasks/#{task.id}"
    end
  end

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
