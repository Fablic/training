# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /tasks/:id', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'shows a task' do
    task = Task.create(title: 'Existing Task', description: 'This is an existing task.')
    visit "/tasks/#{task.id}"

    expect(page).to have_content('Existing Task')
    expect(page).to have_content('This is an existing task.')
  end
end
