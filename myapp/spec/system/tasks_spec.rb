require 'rails_helper'

RSpec.describe 'Tasks', type: :system do 
  describe 'index page' do 
    it 'show page title, list and delete buttons' do 
      Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)
      Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5)

      visit tasks_path

      expect(page).to have_content('Task List')

      expect(page).to have_content('Test title 1')
      expect(page).to have_content('Test title 2')

      expect(page).to have_selector("input[type='submit'][value='Delete']", count: 2)
    end

    context 'delete a task' do
      it "delete the task with button" do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit tasks_path
        click_on task.id.to_s

        expect(page).to have_no_content('Task Detail 1')
        expect(Task.all.length).to eq(0)
        expect(page).to have_content('Deleted task successfully!')
      end
    end

    it 'show tasks in due date order' do 
      Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)
      Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 10)
      Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 15)
      
      visit tasks_path

      expect(page.text).to match(/Test title 3.*\n.*Test title 2.*\n.*Test title 1/)
    end
  end

  describe 'new page and create task' do 
    it 'show page title and form' do 
      visit new_task_path
      
      expect(page).to have_content('Create a new task')

      expect(page).to have_field('Title')
      expect(page).to have_field('Description')
      expect(page).to have_field('Due')

      expect(page).to have_selector("input[type='submit'][value='Submit Task']")
    end

    it 'create new task and show flash message' do 
      visit new_task_path

      fill_in 'Title', with: 'New Task Title'
      fill_in 'Description', with: 'New Task Description'
      new_time = Time.zone.now + 5
      fill_in 'Due', with: new_time

      click_on 'Submit Task'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('New task was created successfully!')
      expect(Task.all.length).to eq(1)

      visit task_path(Task.last)

      expect(page).to have_content('New Task Title')
      expect(page).to have_content('New Task Description')
      expect(page).to have_content(I18n.l new_time)
    end

    context 'input invalid value' do 
      it 'should show error message for empty title' do 
        visit new_task_path 

        fill_in 'Description', with: 'New Task Description'
        fill_in 'Due', with: Time.zone.now + 5

        click_on 'Submit Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Title must not be blank!')
      end

      it 'should show error message for empty description' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Due', with: Time.zone.now + 5

        click_on 'Submit Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Description must not be blank!')
      end

      it 'should show error message for empty due date' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'

        click_on 'Submit Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Due must be specified!')
      end

      it 'should show error message for past due date' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'
        fill_in 'Due', with: Time.zone.now - 60

        click_on 'Submit Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content("Due can't be in the past")
      end
    end
  end

  describe 'detail page' do
    it 'show the detail of the task' do 
      new_time = Time.zone.now + 5
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: new_time)
      
      visit task_path(task)

      expect(page).to have_content('Task Detail')

      expect(page).to have_content('Title')
      expect(page).to have_content('Test title 1')
      expect(page).to have_content(I18n.l(new_time))
    end
  end

  describe 'edit task page' do 
    it 'show fileds with values inside' do 
      previous_time = Time.zone.now + 5
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: previous_time)
      
      visit edit_task_path(task)

      expect(page).to have_content('Edit the task')

      expect(page).to have_field('Title', with: 'Test title 1')
      expect(page).to have_field('Description', with: 'Test Description 1')
      expect(page).to have_field('Due', with: I18n.l(previous_time, format: :field))

      expect(page).to have_selector("input[type='submit'][value='Update Task']")
    end

    it 'redirect to index page after submit' do 
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

      visit edit_task_path(task)

      fill_in 'Title', with: 'Edit Task Title'
      fill_in 'Description', with: 'Edit Task Description'
      edit_time = Time.zone.now + 5
      fill_in 'Due', with: edit_time

      click_on 'Update Task'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('Edit task successfully!')

      visit task_path(task)

      expect(page).to have_content('Edit Task Title')
      expect(page).to have_content('Edit Task Description')
      expect(page).to have_content(I18n.l(edit_time))
    end

    context 'edit with invalid inputs' do 
      it 'should show error message for empty title' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit edit_task_path(task)

        fill_in 'Title', with: ''

        click_on 'Update Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Title must not be blank!')
      end

      it 'should show error message for empty description' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit edit_task_path(task)

        fill_in 'Description', with: ''

        click_on 'Update Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Description must not be blank!')
      end

      it 'should show error message for empty due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit edit_task_path(task)

        fill_in 'Due', with: ''

        click_on 'Update Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Due must be specified!')
      end

      it 'should show error message for past due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit edit_task_path(task)

        fill_in 'Due', with: Time.zone.now.prev_day

        click_on 'Update Task'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content("Due can't be in the past")
      end

      it 'should NOT show error message if not change due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5)

        visit edit_task_path(task)

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'

        click_on 'Update Task'

        expect(current_path).to eq(tasks_path)
      end
    end
  end
end
