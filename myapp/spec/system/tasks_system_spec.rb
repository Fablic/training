# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks (System)', type: :system do
  let!(:task1) { create(:task, name: 'task1', status: 2, priority: 0, label: 'aaa', due_date: Faker::Time.forward(days: 1, period: :evening)) }
  let!(:task2) { create(:task, name: 'task2', status: 2, priority: 0, label: 'aaa', due_date: Faker::Time.forward(days: 2, period: :evening)) }

  it 'Add new task' do
    visit tasks_url
    click_on 'New Task'
    fill_in 'task[name]', with: 'task3'
    fill_in 'task[desc]', with: 'task3 desc'
    select('Done', from: 'task[status]')
    fill_in 'task[label]', with: 'task3 desc'
    select('Low', from: 'task[priority]')
    fill_in('task[due_date]', with: Faker::Time.forward(days: 3, period: :evening))
    click_button 'Create Task'
    expect(page).to have_text('Task was successfully created.')
  end

  it 'Sort using due_date asc' do
    expected_order = %w[task1 task2]
    visit tasks_url
    visit root_path(sort_key: 'due_date', sort_val: 'asc')
    expect(page.all('.task-name').map(&:text)).to eq expected_order
  end

  it 'Sort using due_date desc' do
    expected_order = %w[task2 task1]
    visit tasks_url
    visit root_path(sort_key: 'due_date', sort_val: 'desc')
    expect(page.all('.task-name').map(&:text)).to eq expected_order
  end
end
