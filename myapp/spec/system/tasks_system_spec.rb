# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks (System)', type: :system do
  it 'tasks is ordered by created_at with descending order' do
    expected_order = %w[task2 task1]
    visit tasks_url
    click_on 'New Task'
    fill_in 'task[name]', with: 'task1'
    fill_in 'task[desc]', with: 'task1 desc'
    select('Done', from: 'task[status]')
    fill_in 'task[label]', with: 'task1 desc'
    select('Low', from: 'task[priority]')
    click_button 'Create Task'
    expect(page).to have_text('Task was successfully created.')

    visit new_task_url
    fill_in 'task[name]', with: 'task2'
    fill_in 'task[desc]', with: 'task1 desc'
    select('Done', from: 'task[status]')
    fill_in 'task[label]', with: 'task1 desc'
    select('Low', from: 'task[priority]')
    click_button 'Create Task'
    expect(page).to have_text('Task was successfully created.')
    visit tasks_url
    expect(page.all('.task-name').map(&:text)).to eq expected_order
  end
end
