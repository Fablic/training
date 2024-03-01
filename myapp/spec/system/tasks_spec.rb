require 'rails_helper'

RSpec.describe "Tasks", type: :system do

  describe 'page rendering' do
    it 'homepage should be the task list page' do
      visit '/'
      expect(page).to have_content 'Tasks'
    end

    it 'task list page should be shown' do
      create(:task, name: "test_task")
      visit '/tasks'
      expect(page).to have_content 'Tasks'
      expect(page).to have_link 'test_task'
    end

    it 'task detail page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}"
      expect(page).to have_content "#{task.name}"
    end

    it 'task edit page should be shown' do
      task = create(:task)
      visit "/tasks/#{task.id}/edit"
      expect(page).to have_content 'Edit task'
    end

    it 'task create page should be shown' do
      visit "/tasks/new"
      expect(page).to have_content 'Input New task'
    end
  end

  describe 'task creation' do
    it 'task created successfully' do
        visit '/'
        click_link('New task')
        # expect(Task.all.length).to eq 0
        fill_in 'task[name]', with: 'a_new_task'
        fill_in 'task[description]', with: 'new task description'
        select 'Done', from: 'Status'
        select 'Low', from: 'Priority'
        fill_in 'task[duedate]', with: '2024-08-08'
        click_on "Update"
        expect(page).to have_content "a_new_task"
        expect(Task.last.name).to eq 'a_new_task'
        # expect(Task.all.length).to eq 1
      end
    end
  
    describe 'task update' do
      before do
        create(:task, name: "task_before_edit", description: "description before")
      end
  
      it 'task updated successfully' do
        visit '/'
        click_on('Edit')
        fill_in 'task[name]', with: 'task_after_edit'
        fill_in 'task[description]', with: 'description after'
        click_on "Update"
        expect(page).to have_content 'task_after_edit'
        expect(Task.last.name).to eq 'task_after_edit'
        # expect(Task.all.length).to eq 1
      end
    end
  
    describe 'task deletion' do
      before do
        create(:task, name: "task_should_be_deleted")
      end
  
      it 'task deleted successfully' do
        visit '/'
        # expect(Task.all.length).to eq 1
        click_on "Delete"
        # expect(Task.all.length).to eq 0
      end
    end

  # describe 'show tasks list ordered by specific column in ascending/descending order' do
  #   before do
  #     create(:task, name: 'Task1', priority: 'High', status: 'Done', duedate: '2024-02-10',created_at: Time.now- 3.days)
  #     create(:task, name: 'Task2', priority: 'Low', status: 'In Progress' , duedate: '2024-02-23',created_at: Time.now- 2.days)
  #     create(:task, name: 'Task3', priority: 'Medium', status: 'Not Started', duedate: '2024-02-12', created_at: Time.now- 1.days)
  #   end

  #   it '3 tasks should be created' do
  #     visit '/'
  #     # expect(Task.all.length).to eq 3
  #   end

  #   it 'by created_time desc/asc' do
  #     visit '/'
  #     click_link('created_at')
  #     expect(page.body.index('Task3')).to be < page.body.index('Task2')
  #     expect(page.body.index('Task2')).to be < page.body.index('Task1')
  #     click_link('created_at')
  #     expect(page.body.index('Task1')).to be < page.body.index('Task2')
  #     expect(page.body.index('Task2')).to be < page.body.index('Task3')
  #   end


  #   it 'by priority asc' do
  #     visit '/'
  #     click_link('Priority')
  #     expect(page.body.index('Task1')).to be < page.body.index('Task3')
  #     expect(page.body.index('Task3')).to be < page.body.index('Task2')
  #     click_link('Priority')
  #     expect(page.body.index('Task2')).to be < page.body.index('Task3')
  #     expect(page.body.index('Task3')).to be < page.body.index('Task1')
  #   end

  #   it 'by status asc' do
  #     visit '/'
  #     click_link('Status')
  #     expect(page.body.index('Task1')).to be < page.body.index('Task2')
  #     expect(page.body.index('Task2')).to be < page.body.index('Task3')
  #     click_link('Status')
  #     expect(page.body.index('Task3')).to be < page.body.index('Task2')
  #     expect(page.body.index('Task2')).to be < page.body.index('Task1')
  #   end 

  #     it 'by duedate asc' do
  #       visit '/'
  #       click_link('Duedate')
  #       expect(page.body.index('Task1')).to be < page.body.index('Task3')
  #       expect(page.body.index('Task3')).to be < page.body.index('Task2')
  #       click_link('Duedate')
  #       expect(page.body.index('Task2')).to be < page.body.index('Task3')
  #       expect(page.body.index('Task3')).to be < page.body.index('Task1')
  #     end
  # end

  it 'valid if task has all required contents' do
    task = create(:task)
    expect(task).to be_valid
  end

  it 'invalid if one or more required contents are missing' do
    task = Task.new(
      name: '',
      description: '',
      priority: '',
      status: '',
      duedate: '2024-08-08'
    )
    expect(task).to be_invalid
  end

  it 'valid if name length is 30' do
    task = build(:task, name: 'a'*30)
    expect(task).to be_valid
  end

  it 'invalid if name is too long' do
    task = build(:task, name: 'a'*31)
    expect(task).to be_invalid
  end

  it 'valid if description length is 255' do
    task = build(:task, description: 'a'*255)
    expect(task).to be_valid
  end

  it 'invalid if description is too long' do
    task = build(:task, description: 'a'*256)
    expect(task).to be_invalid
  end


  it 'valid if task duedate is future' do
    task = build(:task, duedate: '2024-08-08')
    expect(task).to be_valid
  end

  it 'invalid if task duedate is past' do
    task = build(:task, duedate: Date.today - 1)
    expect(task).to be_invalid

    it 'by status asc' do
      visit '/'
      click_link('Status')
      expect(page.body.index('Task1')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task3')
      click_link('Status')
      expect(page.body.index('Task3')).to be < page.body.index('Task2')
      expect(page.body.index('Task2')).to be < page.body.index('Task1')
    end 

    it 'by duedate asc' do
      visit '/'
      click_link('Duedate')
      expect(page.body.index('Task1')).to be < page.body.index('Task3')
      expect(page.body.index('Task3')).to be < page.body.index('Task2')
      click_link('Duedate')
      expect(page.body.index('Task2')).to be < page.body.index('Task3')
      expect(page.body.index('Task3')).to be < page.body.index('Task1')
      end

  end
end

  


