require 'rails_helper'

RSpec.describe 'Task Sorting', type: :system do
  # Create a user
  let(:user) { create(:user) }
  # Create tasks with different creation and dealine timestamps for testing sorting
  let!(:task1) { create(:task, name: 'Task 1', created_at: Time.current - 3.days, deadline: Date.today + 3.days, user: user) }
  let!(:task2) { create(:task, name: 'Task 2', created_at: Time.current - 1.day, deadline: Date.today + 1.day, user: user) }
  let!(:task3) { create(:task, name: 'Task 3', created_at: Time.current - 2.days, deadline: Date.today + 2.days, user: user) }

  it 'displays tasks sorted by default' do
    visit tasks_path

    # Find all task names on the page and store them in an array
    task_names_on_page = all('table tbody tr td:nth-child(1)').map(&:text)

    # Ensure that tasks are displayed in default order of id
    expect(task_names_on_page).to eq(['Task 1', 'Task 2', 'Task 3'])
  end

  it 'displays tasks sorted by created_at in descending order' do
    visit tasks_path(sort_by: 'created_at', sort_order: 'desc')

    task_names_on_page = page.all('table tbody tr td:first-child').map(&:text)

    expect(task_names_on_page).to eq(['Task 2', 'Task 3', 'Task 1'])
  end

  it 'displays tasks sorted by created_at in ascending order' do
    visit tasks_path(sort_by: 'created_at', sort_order: 'asc')

    task_names_on_page = page.all('table tbody tr td:first-child').map(&:text)

    expect(task_names_on_page).to eq(['Task 1', 'Task 3', 'Task 2'])
  end

  it 'displays tasks sorted by deadline in descending order' do
    visit tasks_path(sort_by: 'deadline', sort_order: 'desc')

    task_names_on_page = page.all('table tbody tr td:first-child').map(&:text)

    expect(task_names_on_page).to eq(['Task 1', 'Task 3', 'Task 2'])
  end

  it 'displays tasks sorted by deadline in ascending order' do
    visit tasks_path(sort_by: 'deadline', sort_order: 'asc')

    task_names_on_page = page.all('table tbody tr td:first-child').map(&:text)

    expect(task_names_on_page).to eq(['Task 2', 'Task 3', 'Task 1'])
  end
end
