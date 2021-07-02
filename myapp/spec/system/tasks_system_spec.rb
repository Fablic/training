# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks (System)', type: :system do
  let!(:task1) { create(:task, name: 'task1', status: 1, priority: 0, label: 'aaa', due_date: Faker::Time.forward(days: 1, period: :evening)) }
  let!(:task2) { create(:task, name: 'task2', status: 1, priority: 0, label: 'aaa', due_date: Faker::Time.forward(days: 2, period: :evening)) }
  let!(:task3) { create(:task, name: 'task3', status: 2, priority: 0, label: 'aaa', due_date: Faker::Time.forward(days: 3, period: :evening)) }

  context 'CRUDing task' do
    it 'Add new task' do
      visit tasks_url
      page.find('.newtask').click
      fill_in 'task[name]', with: 'task4'
      fill_in 'task[desc]', with: 'task4 desc'
      select('Done', from: 'task[status]')
      fill_in 'task[label]', with: 'task4 desc'
      select('Low', from: 'task[priority]')
      fill_in('task[due_date]', with: Faker::Time.forward(days: 3, period: :evening))
      click_button 'Create Task'
      expect(page).to have_text('Task was successfully created.')
    end
  end

  context 'Sorting tasks' do
    it 'using created_at desc' do
      expected_order = %w[task3 task2 task1]
      visit tasks_url
      expect(page.all('.task-name').map(&:text)).to eq expected_order
    end
  end

  context 'Searching with status' do
    it 'Record found' do
      tasks = Task.ransack({ name_cont: nil, status_eq: 2 }).result
      expect(tasks.count).to eq 1
      expect(tasks).to include(task3)
    end

    it 'Record not found' do
      expect(Task.ransack({ name_cont: nil, status_eq: 0 }).result.count).to eq 0
    end
  end

  context 'Searching with name' do
    it 'is record found' do
      tasks = Task.ransack({ name_cont: 'task1', status_eq: nil }).result
      expect(tasks.count).to eq 1
      expect(tasks).to include(task1)
    end

    it 'is record not found' do
      expect(Task.ransack({ name_cont: 'task4', status_eq: nil }).result.count).to eq 0
    end
  end

  context 'Searching with name and status' do
    it 'is record found' do
      tasks = Task.ransack({ name_cont: 'task1', status_eq: 1 }).result
      expect(tasks.count).to eq 1
      expect(tasks).to include(task1)
    end

    it 'is record not found' do
      expect(Task.ransack({ name_cont: 'task4', status_eq: 2 }).result.count).to eq 0
    end
  end
end
