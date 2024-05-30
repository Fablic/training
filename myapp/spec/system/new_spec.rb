# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /task/new', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'enables me to create tasks' do
    visit '/tasks/new'

    fill_in 'Title', with: 'My Task'
    fill_in 'Description', with: 'This is my task.'
    click_on 'Create Task'

    expect(page).to have_content('Task was successfully created.')
    expect(page).to have_content('My Task')
    expect(page).to have_content('This is my task.')
  end
end
