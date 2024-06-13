# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /task/new', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'enables me to create tasks' do
    visit new_task_path

    fill_in 'Title', with: 'My Task'
    fill_in 'Description', with: 'This is my task.'
    fill_in 'Deadline', with: 2.days.from_now.strftime('%Y-%m-%d %H:%M:%S')
    click_on 'Create Task'

    expect(page).to have_content('Task was successfully created.')
    expect(page).to have_content('My Task')
    expect(page).to have_content('This is my task.')
  end

  it 'shows an error message if task creation fails due to missing title' do
    visit '/tasks/new'

    fill_in 'Description', with: 'This is a test task without a title.'
    click_on 'Create Task'

    expect(page).to have_text('タイトルを入力してください。')
  end

  it 'shows an error message if the task title is too long' do
    visit '/tasks/new'

    fill_in 'Title', with: 'a' * 51
    fill_in 'Description', with: 'A valid description.'
    click_on 'Create Task'

    expect(page).to have_text('タイトルは50文字以内で入力してください。')
  end

  it 'shows an error message if the task description is too long' do
    visit '/tasks/new'

    fill_in 'Title', with: 'My Task'
    fill_in 'Description', with: 'a' * 501
    click_on 'Create Task'

    expect(page).to have_text('説明文は500文字以内で入力してください。')
  end
end
