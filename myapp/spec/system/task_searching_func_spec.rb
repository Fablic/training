require 'rails_helper'

RSpec.describe 'Task Search', type: :system do
  before do
    # Create a user because we have foreign key
    create(:user)
  end

  it 'allows users to search only by status' do
    visit tasks_path

    task1 = create(:task, title: 'Test Task latest one', status: :not_started)
    task2 = create(:task, title: 'Test Task created on second', status: :in_progress)
    task3 = create(:task, title: 'Test Task first one', status: :completed)

    select 'Completed', from: 'q[status_eq]'
    click_button 'search'

    expect(page).to have_content(task3.title)
    expect(page).not_to have_content(task2.title)
    expect(page).not_to have_content(task1.title)
  end

  it 'allows users to search only by partial title' do
    visit tasks_path

    task1 = create(:task, title: 'Test Task latest one', status: :not_started)
    task2 = create(:task, title: 'Test Task created on second', status: :in_progress)
    task3 = create(:task, title: 'Test Task first one', status: :completed)

    fill_in 'q[title_cont]', with: 'creat'
    click_button 'search'

    expect(page).to have_content(task2.title)
    expect(page).not_to have_content(task1.title)
    expect(page).not_to have_content(task3.title)
  end

  it 'allows users to search by title and status' do
    visit tasks_path

    task1 = create(:task, title: 'Test Task latest one', status: :not_started)
    task2 = create(:task, title: 'Test Task created on second', status: :in_progress)
    task3 = create(:task, title: 'Test Task first one', status: :completed)

    fill_in 'q[title_cont]', with: 'lat'
    select 'Not started', from: 'q[status_eq]'
    click_button 'search'

    expect(page).to have_content(task1.title)
    expect(page).not_to have_content(task2.title)
    expect(page).not_to have_content(task3.title)
  end

  it 'allows users to search by title and status which will not found' do
    visit tasks_path

    task1 = create(:task, title: 'Test Task latest one', status: :not_started)
    task2 = create(:task, title: 'Test Task created on second', status: :in_progress)
    task3 = create(:task, title: 'Test Task first one', status: :completed)

    fill_in 'q[title_cont]', with: 'not exists'
    select 'Not started', from: 'q[status_eq]'
    click_button 'search'

    expect(page).not_to have_content(task1.title)
    expect(page).not_to have_content(task2.title)
    expect(page).not_to have_content(task3.title)
  end
end
