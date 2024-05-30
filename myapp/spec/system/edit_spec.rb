# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /tasks/:id/edit', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'enables me to edit tasks' do
    task = Task.create(title: 'Edit Me', description: 'Edit this task.')
    visit "/tasks/#{task.id}/edit"

    fill_in 'Title', with: 'Edited Task'
    fill_in 'Description', with: 'This task has been edited.'
    click_on 'Update Task'

    expect(page).to have_content('Task was successfully updated.')
    expect(page).to have_content('Edited Task')
    expect(page).to have_content('This task has been edited.')
  end
end
