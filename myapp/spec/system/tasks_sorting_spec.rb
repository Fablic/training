require 'rails_helper'

RSpec.describe 'Task Sorting', type: :system do
  before do
    # Create a user
    @user = create(:user)
    # Create tasks with different creation timestamps for testing sorting
    @task1 = create(:task, name: 'Task 1', created_at: Time.current - 3.days)
    @task2 = create(:task, name: 'Task 2', created_at: Time.current - 1.day)
    @task3 = create(:task, name: 'Task 3', created_at: Time.current - 2.days)
    let!(:task1) { create(:task, name: 'Task 1', created_at: Time.current - 3.days, deadline: Date.today + 3.days) }
    let!(:task2) { create(:task, name: 'Task 2', created_at: Time.current - 1.day, deadline: Date.today + 1.day) }
    let!(:task3) { create(:task, name: 'Task 3', created_at: Time.current - 2.days, deadline: Date.today + 2.days) }

    # Visit the task list page
    visit tasks_path
  end

  it 'displays tasks sorted by default' do
    # Find all task names on the page and store them in an array
    task_names_on_page = all('table tbody tr td:nth-child(1)').map(&:text)

    # Ensure that tasks are displayed in default order of id
    expect(task_names_on_page).to eq(['Task 1', 'Task 2', 'Task 3'])
  end

  it 'llows changing sort order to descending order' do
    click_link 'Sort by Newest'
    # Find all task names on the page and store them in an array
    task_names_on_page = all('table tbody tr td:nth-child(1)').map(&:text)

    # Ensure that tasks are displayed in descending order of creation date
    expect(task_names_on_page).to eq(['Task 2', 'Task 3', 'Task 1'])
  end

  it 'allows changing sort order to ascending' do
    # Click the link to sort tasks by oldest first
    click_link 'Sort by Oldest'

    # Find all task names on the page and store them in an array
    task_names_on_page = all('table tbody tr td:nth-child(1)').map(&:text)

    # Ensure that tasks are displayed in ascending order of creation date
    expect(task_names_on_page).to eq(['Task 1', 'Task 3', 'Task 2'])
  end
end
