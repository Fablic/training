# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task Sorting' do
  before do
    # Create a user because we have foreign key
    create(:user)
  end

  it 'check sort functionality by items as latest first' do
    # Tasks with different timestamps
    create(:task, title: 'Test Task latest one', created_at: Time.current)
    create(:task, title: 'Test Task first one', created_at: 2.days.ago)
    create(:task, title: 'Test Task created on second', created_at: 1.day.ago)

    visit tasks_path

    click_link 'Sort by latest'

    task_titles_only = all('table tr td:nth-child(1)').map(&:text)

    # check the latest order
    expect(task_titles_only).to eq(['Test Task latest one', 'Test Task created on second', 'Test Task first one'])
  end

  it 'check sort functionality by items as oldest first' do
    # Tasks with different timestamps
    create(:task, title: 'Test Task latest one', created_at: Time.current)
    create(:task, title: 'Test Task first one', created_at: 2.days.ago)
    create(:task, title: 'Test Task created on second', created_at: 1.day.ago)

    visit tasks_path

    click_link 'Sort by oldest'
    task_titles_only = all('table tr td:nth-child(1)').map(&:text)

    # check the oldest order
    expect(task_titles_only).to eq(['Test Task first one', 'Test Task created on second', 'Test Task latest one'])
  end
end
