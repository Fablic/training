require 'rails_helper'

RSpec.describe 'Task Search', type: :system do
  before do
    # Create some tasks for testing
    create(:user)
    create(:task, name: 'Task 1', status: 'Not Started')
    create(:task, name: 'Task 2', status: 'In Progress')
    create(:task, name: 'Task 3', status: 'Done')
    visit tasks_path
  end

  it 'allows users to search by name and status' do
    fill_in 'Name', with: 'Task 1'
    select 'Not Started', from: 'Status'
    click_button 'Search'

    expect(page).to have_content('Task 1')
    expect(page).not_to have_content('Task 2')
    expect(page).not_to have_content('Task 3')
  end

  it 'displays "No tasks found" message when no search results' do
    fill_in 'Name', with: 'Non-existent Task'
    select 'Done', from: 'Status'
    click_button 'Search'

    expect(page).to have_content('No tasks found')
  end
end
