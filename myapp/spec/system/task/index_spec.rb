# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task management', type: :system do
  before do
    driven_by(:rack_test)
    @task1 = Task.create!(title: 'Task 1', status: '未着手', created_at: 1.day.ago, deadline: 2.days.from_now)
    @task2 = Task.create!(title: 'Task 2', status: '着手中', created_at: 2.days.ago, deadline: 3.days.from_now)
    @task3 = Task.create!(title: 'Task 3', status: '完了', created_at: 3.days.ago, deadline: 4.days.from_now)
  end

  it 'displays tasks in descending order of creation' do
    visit tasks_path(sort_by: 'created_at', sort_direction: 'desc')

    titles = page.all('h5.card-title').map(&:text)

    expect(titles).to eq(['Title: Task 1', 'Title: Task 2', 'Title: Task 3'])
  end

  it 'allows the user to search tasks by title' do
    visit tasks_path
    fill_in 'Title', with: 'Task 1'
    click_button 'Search'
    expect(page).to have_content('Task 1')
    expect(page).not_to have_content('Task 2')
    expect(page).not_to have_content('Task 3')
  end

  it 'allows the user to search tasks by status' do
    visit tasks_path
    select '未着手', from: 'Status'
    click_button 'Search'
    expect(page).to have_content('Task 1')
    expect(page).not_to have_content('Task 2')
    expect(page).not_to have_content('Task 3')
  end

  it 'allows the user to sort tasks by created_at ascending' do
    visit tasks_path
    click_link 'Sort by Created At (Asc)'
    titles = page.all('h5.card-title').map(&:text)
    expect(titles).to eq(['Title: Task 3', 'Title: Task 2', 'Title: Task 1'])
  end

  it 'allows the user to sort tasks by created_at descending' do
    visit tasks_path
    click_link 'Sort by Created At (Desc)'
    titles = page.all('h5.card-title').map(&:text)
    expect(titles).to eq(['Title: Task 1', 'Title: Task 2', 'Title: Task 3'])
  end

  it 'allows the user to sort tasks by deadline ascending' do
    visit tasks_path
    click_link 'Sort by Deadline (Asc)'
    titles = page.all('h5.card-title').map(&:text)
    expect(titles).to eq(['Title: Task 1', 'Title: Task 2', 'Title: Task 3'])
  end

  it 'allows the user to sort tasks by deadline descending' do
    visit tasks_path
    click_link 'Sort by Deadline (Desc)'
    titles = page.all('h5.card-title').map(&:text)
    expect(titles).to eq(['Title: Task 3', 'Title: Task 2', 'Title: Task 1'])
  end
end

