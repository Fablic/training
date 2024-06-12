# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task management', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'displays tasks in descending order of creation' do
    older_task = Task.create!(title: 'Older', description: 'Older task', created_at: 1.day.ago,
                              deadline: 2.days.from_now)
    newer_task = Task.create!(title: 'Newer', description: 'Newer task', created_at: 1.hour.ago,
                              deadline: 2.days.from_now)

    visit tasks_path(sort_by: 'created_at', sort_direction: 'desc')

    titles = page.all('h5.card-title').map(&:text)

    expect(titles).to eq(['Title: Newer', 'Title: Older'])
  end
end
