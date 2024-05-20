require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task1 = Task.create!(title: 'Test title 1', description: 'Test Description 1')
    @task2 = Task.create!(title: 'Test title 2', description: 'Test Description 2')
  end 

  describe 'index page' do 
    it 'show page title, list and delete buttons' do 
      visit tasks_path

      expect(page).to have_content('Task List')

      expect(page).to have_content('Test title 1')
      expect(page).to have_content('Test title 2')

      expect(page).to have_selector("input[type='submit'][value='Delete']", count: 2)
    end

    context 'delete a task' do
      it "delete the task with button" do 
        visit tasks_path
        click_on @task1.id.to_s

        expect(page).to have_no_content('Task Detail 1')
        expect(Task.all.length).to eq(1)
        expect(page).to have_content('Deleted task successfully!')
      end
    end
  end

  describe 'new page and create task' do 
    it 'show page title and form' do 
      visit new_task_path
      
      expect(page).to have_content('Create a new task')

      expect(page).to have_field('Title')
      expect(page).to have_field('Description')

      expect(page).to have_selector("input[type='submit'][value='Save Task']")
    end

    it 'create new task and show flash message' do 
      visit new_task_path

      fill_in 'Title', with: 'New Task Title'
      fill_in 'Description', with: 'New Task Description'

      click_on 'Save Task'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('New task was created successfully!')
      expect(Task.all.length).to eq(3)

      visit task_path(Task.last)

      expect(page).to have_content('New Task Title')
      expect(page).to have_content('New Task Description')
    end
  end

  describe 'detail page' do
    it 'show the detail of the task' do 
      visit task_path(@task1)

      expect(page).to have_content('Task Detail')

      expect(page).to have_content('Title')
      expect(page).to have_content('Test title 1')

      expect(page).to have_content('Description')
      expect(page).to have_content('Test Description 1')
    end
  end

  describe 'edit task page' do 
    it 'show page title' do 
      visit edit_task_path(@task1)

      expect(page).to have_content('Edit the task')

      expect(page).to have_field('Title', with: 'Test title 1')
      expect(page).to have_field('Description', with: 'Test Description 1')

      expect(page).to have_selector("input[type='submit'][value='Update Task']")
    end

    it 'redirect to index page after submit' do 
      visit edit_task_path(@task1)

      fill_in 'Title', with: 'Edit Task Title'
      fill_in 'Description', with: 'Edit Task Description'

      click_on 'Update Task'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('Edit task successfully!')

      visit task_path(@task1)

      expect(page).to have_content('Edit Task Title')
      expect(page).to have_content('Edit Task Description')
    end
  end

  
end
