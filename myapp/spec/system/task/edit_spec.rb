# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /tasks/:id/edit', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'enables me to edit tasks' do
    task = Task.create(title: 'Edit Me', description: 'Edit this task.', deadline: 2.days.from_now)
    visit edit_task_path(task)
  
    fill_in 'Title', with: 'Edited Task'
    fill_in 'Description', with: 'This task has been edited.'
    click_on 'Update Task'
  
    expect(page).to have_content('Task was successfully updated.')
    expect(page).to have_content('Edited Task')
    expect(page).to have_content('This task has been edited.')
  end
  
  it 'shows an error message if task creation fails due to missing title' do
    task = Task.create(title: 'Edit Me', description: 'Edit this task.', deadline: 2.days.from_now)
    visit edit_task_path(task)
  
    fill_in 'Title', with: ''
    fill_in 'Description', with: 'This is a test task without a title.'
    click_on 'Update Task'
  
    expect(page).to have_text("タイトルを入力してください。")
  end
  
  it 'shows an error message if the task title is too long' do
    task = Task.create(title: 'Edit Me', description: 'Edit this task.', deadline: 2.days.from_now)
    visit edit_task_path(task)
  
    fill_in 'Title', with: 'a' * 51
    fill_in 'Description', with: 'A valid description.'
    click_on 'Update Task'
  
    expect(page).to have_text("タイトルは50文字以内で入力してください。")
  end
  
  it 'shows an error message if the task description is too long' do
    task = Task.create(title: 'Edit Me', description: 'Edit this task.', deadline: 2.days.from_now)
    visit edit_task_path(task)
  
    fill_in 'Title', with: 'My Task'
    fill_in 'Description', with: 'a' * 501
    click_on 'Update Task'
  
    expect(page).to have_text("説明文は500文字以内で入力してください。")
  end  
end
