require 'rails_helper'

RSpec.describe 'Tasks', type: :system do 
  before do 
    user1 = User.create!(username: 'username', password: 'password')
    @user1_id = user1.id 

    @label1 = Label.create(label_name: 'Label 1')
    @label2 = Label.create(label_name: 'Label 2')

    visit login_path 

    fill_in 'username', with: 'username'
    fill_in 'password', with: 'password'
    click_on 'commit'
  end

  describe 'index page' do 
    context 'render all components' do 
      it 'show page title, list and delete buttons' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5, status: 'pending')
  
        visit tasks_path
  
        # page title
        expect(page).to have_content('Task List')
  
        # filter field
        ## search title
        expect(page).to have_field('Search Title:')
        ## search status
        expect(page).to have_select('Search Status:')
        ## sort by
        expect(page).to have_select('Sort by')
        ## sort order
        expect(page).to have_select('Order')
        ## filter button
        expect(page).to have_button('Filter')
  
        # tasks' title
        expect(page).to have_content('Test title 1')
        expect(page).to have_content('Test title 2')
  
        expect(page).to have_button('Delete', count: 2)
      end

      it 'show pagination bar' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 4', description: 'Test Description 4', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 5', description: 'Test Description 5', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 6', description: 'Test Description 6', due: Time.zone.now + 5, status: 'pending')

        visit tasks_path

        expect(page).to have_selector('ul.pagination')
      end

      it 'Show labels for each task' do 
        task = Task.create(title: 'Test Title 1', description: 'Description', due: Time.zone.now + 5, status: 'pending', user_id: @user1_id)
        task.labels << @label1

        expect(page).to have_content('Label 1')
      end
    end

    context 'when there are some tasks' do
      it 'delete the task when clicking Delete button' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit tasks_path
        click_on "Delete#{task.id}"

        expect(page).to have_no_content('Task Detail 1')
        expect(Task.all.length).to eq(0)
        expect(page).to have_content('Deleted task successfully!')
      end

      it 'jump to edit page when clicking Edit button' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit tasks_path
        click_on "Edit#{task.id}"

        expect(current_path).to eq(edit_task_path(task))
      end

      it 'show the specified page with tasks when page link clicked' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 4', description: 'Test Description 4', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 5', description: 'Test Description 5', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 6', description: 'Test Description 6', due: Time.zone.now + 5, status: 'pending')

        visit tasks_path

        click_link '2'

        expect(page).to have_content('Test title 1')
      end
    end

    context 'show tasks in specified order' do
      it 'show tasks in created date in desc order by default' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 5, status: 'pending')

        visit tasks_path 

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Test title 3')
        expect(titles[1]).to have_content('Test title 2')
        expect(titles[2]).to have_content('Test title 1')
      end

      it 'show tasks in created date in asc order when specified' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 5, status: 'pending')
        
        visit tasks_path

        select 'Asc', from: 'Order'
        click_on 'Filter'

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Test title 1')
        expect(titles[1]).to have_content('Test title 2')
        expect(titles[2]).to have_content('Test title 3')
      end

      it 'show tasks in due date in desc order when specified' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 10, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 15, status: 'pending')
        
        visit tasks_path

        select 'Due Date', from: 'Sort by'
        click_on 'Filter'

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Test title 3')
        expect(titles[1]).to have_content('Test title 2')
        expect(titles[2]).to have_content('Test title 1')
      end

      it 'show tasks in due date in asc order when specified' do 
        Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')
        Task.create!(title: 'Test title 2', description: 'Test Description 2', due: Time.zone.now + 10, status: 'pending')
        Task.create!(title: 'Test title 3', description: 'Test Description 3', due: Time.zone.now + 15, status: 'pending')
        
        visit tasks_path

        select 'Due Date', from: 'Sort by'
        select 'Asc', from: 'Order'
        click_on 'Filter'

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Test title 1')
        expect(titles[1]).to have_content('Test title 2')
        expect(titles[2]).to have_content('Test title 3')
      end 
    end

    context 'search by title or status or label' do 
      it 'search title' do 
        Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 5,
          status: 'in_progress'
        )

        Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 5,
          status: 'completed'
        )

        visit tasks_path 

        fill_in 'Search Title:', with: 'Task'

        click_on 'Filter'

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Task 2')
        expect(titles[1]).to have_content('Task 1')
      end
      
      it 'search status' do 
        Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 5,
          status: 'in_progress'
        )

        Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 5,
          status: 'completed'
        )

        visit tasks_path 

        select 'Pending', from: 'Search Status:'

        click_on 'Filter'

        titles = find('tbody').all('tr')

        expect(titles[0]).to have_content('Task 1')
      end

      it 'search label' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending',
          user_id: @user1_id
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 5,
          status: 'in_progress',
          user_id: @user1_id
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 5,
          status: 'completed',
          user_id: @user1_id
        )

        task1.labels << @label1
        task2.labels << @label2
        task3.labels << @label1
        task3.labels << @label2

        select 'Label 1', from: 'label_id'

        click_on I18n.t('views.buttons.filter')

        expect(page).to have_content(task1.title)
        expect(page).to have_content(task3.title)
        expect(page).to_not have_content(task2.title)
      end
    end
  end

  describe 'new page and Create' do 
    it 'show page title and form' do 
      visit new_task_path
      
      expect(page).to have_content(I18n.t('views.titles.new_task'))

      expect(page).to have_field('task_title')
      expect(page).to have_field('task_description')
      expect(page).to have_field('task_due')
      expect(page).to have_field('task_status_pending')
      expect(page).to have_field('task_status_in_progress')
      expect(page).to have_field('task_status_completed')
      expect(page).to have_field('task_label_ids')
      expect(page).to have_selector('option', text: 'Label 1')
      expect(page).to have_selector('option', text: 'Label 2')

      expect(page).to have_button('commit')
    end

    it 'create new task and show flash message' do 
      visit new_task_path

      fill_in 'task_title', with: 'New Task Title'
      fill_in 'task_description', with: 'New Task Description'
      new_time = Time.zone.now + 5
      fill_in 'task_due', with: new_time
      select 'Label 1', from: 'task_label_ids'
      choose 'task_status_pending'

      click_on 'commit'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('New task was created successfully!')
      expect(Task.all.length).to eq(1)

      visit task_path(Task.last)

      expect(page).to have_content('New Task Title')
      expect(page).to have_content('New Task Description')
      expect(page).to have_content(I18n.l(new_time))
      expect(page).to have_content(I18n.t('views.selects.status_pending'))
      expect(page).to have_content('Label 1')
    end

    context 'input invalid value' do 
      it 'should show error message for title less than 5 chars' do 
        visit new_task_path 

        fill_in 'Description', with: 'New Task Description'
        fill_in 'Due', with: Time.zone.now + 5
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('please input more than 5 characters')
      end

      it 'should show error message for title more than 30 chars' do 
        visit new_task_path 

        fill_in 'Title', with: 't' * 31
        fill_in 'Description', with: 'New Task Description'
        fill_in 'Due', with: Time.zone.now + 5
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('30 characters is the maximum allowed')
      end

      it 'should show error message for description less than 10 chars' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Due', with: Time.zone.now + 5
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('please input more than 10 characters')
      end

      it 'should show error message for description more than 300 chars' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'd' * 301
        fill_in 'Due', with: Time.zone.now + 5
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('300 characters is the maximum allowed')
      end

      it 'should show error message for empty due date' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Due must be specified!')
      end

      it 'should show error message for past due date' do 
        visit new_task_path 

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'
        fill_in 'Due', with: Time.zone.now - 60
        choose 'Pending'

        click_on 'Create'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content("Due can't be earlier than now!")
      end
    end
  end

  describe 'detail page' do
    it 'show the detail of the task' do 
      new_time = Time.zone.now + 5
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: new_time, status: 'pending')
      
      visit task_path(task)

      expect(page).to have_content('Task Detail')

      expect(page).to have_content('Title')
      expect(page).to have_content('Test title 1')
      expect(page).to have_content(I18n.l(new_time))
      expect(page).to have_content('Pending')
    end

    it 'should be redirected to index page when trying to access to other"s task' do 
      user2 = User.create!(username: 'username2', password: 'password2')
      task_for_user2 = Task.create(
        title: 'Task for User2',
        description: 'Description for Task',
        due: Time.zone.now + 5,
        status: 'pending',
        user_id: user2.id 
      )

      visit task_path(task_for_user2) 

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('No task found!')
    end
  end

  describe 'edit task page' do 
    it 'show fileds with values inside' do 
      previous_time = Time.zone.now + 5
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: previous_time, status: 'pending')
      
      visit edit_task_path(task)

      expect(page).to have_content('Edit the task')

      expect(page).to have_field('Title', with: 'Test title 1')
      expect(page).to have_field('Description', with: 'Test Description 1')
      expect(page).to have_field('Due', with: I18n.l(previous_time, format: :field))

      expect(page).to have_selector("input[type='submit'][value='Update']")
    end

    it 'redirect to index page after submit' do 
      task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending', user_id: @user1_id)
      p task.labels
      task.labels << @label1

      visit edit_task_path(task)

      fill_in 'task_title', with: 'Edit Task Title'
      fill_in 'task_description', with: 'Edit Task Description'
      edit_time = Time.zone.now + 5
      fill_in 'task_due', with: edit_time
      choose 'task_status_in_progress'
      select 'Label 2', from: 'task_label_ids'

      click_on 'commit'

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('Edit task successfully!')

      visit task_path(task)

      expect(page).to have_content('Edit Task Title')
      expect(page).to have_content('Edit Task Description')
      expect(page).to have_content(I18n.l(edit_time))
      expect(page).to have_content(I18n.t('views.selects.status_in_progress'))
      expect(page).to have_content('Label 2')
    end

    context 'edit with invalid inputs' do 
      it 'should show error message for title less than 5 chars' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Title', with: ''

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('please input more than 5 characters')
      end

      it 'should show error message for title more than 30 chars' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Title', with: 't' * 31

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('30 characters is the maximum allowed')
      end

      it 'should show error message for description less than 10 chars' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Description', with: ''

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('please input more than 10 characters')
      end

      it 'should show error message for description more than 300 chars' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Description', with: 'd' * 301

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('300 characters is the maximum allowed')
      end

      it 'should show error message for empty due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Due', with: ''

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content('Due must be specified!')
      end

      it 'should show error message for past due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Due', with: Time.zone.now.prev_day

        click_on 'Update'

        expect(page).to have_content('You have some invalid inputs!')
        expect(page).to have_content("Due can't be earlier than now!")
      end

      it 'should NOT show error message if not change due date' do 
        task = Task.create!(title: 'Test title 1', description: 'Test Description 1', due: Time.zone.now + 5, status: 'pending')

        visit edit_task_path(task)

        fill_in 'Title', with: 'New Task Title'
        fill_in 'Description', with: 'New Task Description'

        click_on 'Update'

        expect(current_path).to eq(tasks_path)
      end
    end

    it 'should be redirected to index page when trying to access to other"s task edit page' do 
      user2 = User.create!(username: 'username2', password: 'password2')
      task_for_user2 = Task.create(
        title: 'Task for User2',
        description: 'Description for Task',
        due: Time.zone.now + 5,
        status: 'pending',
        user_id: user2.id 
      )

      visit edit_task_path(task_for_user2) 

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('No task found!')
    end
  end
end
