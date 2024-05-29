require 'rails_helper'

RSpec.describe "Task management", type: :system do
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

  it 'displays a task' do
    task = Task.create(title: 'Existing Task', description: 'This is an existing task.')
    visit "/tasks/#{task.id}"
    
    expect(page).to have_content('Existing Task')
    expect(page).to have_content('This is an existing task.')
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

  it 'enables me to delete tasks' do
    task = Task.create(title: 'Delete Me', description: 'Delete this task.')
    visit "/tasks/#{task.id}"
    
    click_button 'Delete'
    
    expect(page).to have_content('Task was successfully deleted.')
    expect(page).not_to have_content('Delete Me')
    expect(page).not_to have_content('Delete this task.')
  end
end