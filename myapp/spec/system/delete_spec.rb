# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /tasks/:id', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'enables me to delete tasks' do
    task = Task.create(title: 'Delete Me', description: 'Delete this task.')
    visit "/tasks/#{task.id}"

    click_button 'Delete'

    expect(page).to have_content('Task was successfully deleted.')
    expect(page).not_to have_content('Delete Me')
    expect(page).not_to have_content('Delete this task.')
  end
end
