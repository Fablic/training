# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task management', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'displays tasks in descending order of creation' do
    older_task = Task.create!(title: 'Older', created_at: 1.day.ago)
    newer_task = Task.create!(title: 'Newer', created_at: 1.hour.ago)

    visit tasks_path

    titles = page.all('h5.card-title').map(&:text)

    expect(titles).to eq(['Title: Newer', 'Title: Older'])
  end
end
