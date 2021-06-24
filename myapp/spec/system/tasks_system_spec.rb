# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks (System)', type: :system do
  let!(:task1) { create(:task, name: 'task1', status: 2, priority: 0, label: 'aaa', due_date: Time.now + 1.day) }
  let!(:task2) { create(:task, name: 'task2', status: 2, priority: 0, label: 'aaa', due_date: Time.now + 2.day) }

  it 'Add new task' do
    visit tasks_url
    click_on 'New Task'
    fill_in 'task[name]', with: 'task3'
    fill_in 'task[desc]', with: 'task3 desc'
    select('Done', from: 'task[status]')
    fill_in 'task[label]', with: 'task3 desc'
    select('Low', from: 'task[priority]')
    fill_in('task[due_date]', with: Time.now + 3.day)
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
