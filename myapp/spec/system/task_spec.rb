require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let!(:task) { FactoryBot.create(:task) }

  describe 'Check the screen transitions' do
    subject { visit root_path }
    it 'check show page' do
      subject
      click_link task.title
      expect(current_path).to eq task_path(task.id)
    end
    it 'check new page' do
      subject
      click_link 'Register a task'
      expect(current_path).to eq new_task_path
    end
  end

  describe 'Check the index page' do
    subject { visit root_path }
    it 'deital' do
      subject
      expect(page).to have_content('Tasks (1)')
      expect(page).to have_content(task.title)
    end
  end
 
  describe 'Check the show page' do
    subject { visit task_path(task.id) }
    it 'deital' do
      subject
      expect(page).to have_content(task.title)
      expect(page).to have_content(task.detail)
      expect(page).to have_link 'EDIT', href: edit_task_path(task)
      expect(page).to have_link 'DELETE', href: task_path(task.id)
    end
  end
 
  describe 'Check the new task' do
    subject { visit new_task_path }

    it 'Can create tasks' do
      title = 'new Title'
      detail = 'new Detail'
      flush = 'Regist Success!'

      subject
      fill_in 'Title', with: title
      fill_in 'Detail', with: detail
      select 'low', from: 'Priority'
      select 'done', from: 'Status'
      fill_in 'Due date', with: Time.zone.now.strftime("%Y-%m-%d")
      click_button 'Register my task'

      expect(page).to have_current_path( root_path )
      expect(page).to have_content(flush)

      click_link title
      expect(page).to have_content(detail)
      expect(page).not_to have_content(flush)
    end

    it 'Can not create tasks' do
      title = 'new Title'
      detail = 'new Detail'
      flush = 'error'

      subject
      fill_in 'Title', with: title
      fill_in 'Detail', with: detail
      select 'low', from: 'Priority'
      select 'done', from: 'Status'
      fill_in 'Due date', with: Time.zone.yesterday.strftime("%Y-%m-%d")
      click_button 'Register my task'

      expect(page).to have_current_path( tasks_path )
      expect(page).to have_content(flush)
    end
  end


  describe 'Check the edit task' do
    subject { visit edit_task_path(task) }

    it 'Can edit tasks' do
      title = 'edit Title'
      detail = 'edit Detail'
      flush = 'Edit Success!'

      subject
      fill_in 'Title', with: title
      fill_in 'Detail', with: detail
      fill_in 'Due date', with: Time.zone.now.strftime("%Y-%m-%d")
      click_button 'Edit my task'

      expect(page).to have_current_path( task_path(task) )
      expect(page).to have_content(flush)
      expect(page).to have_content(title)
      expect(page).to have_content(detail)
    end

    it 'Can not edit tasks' do
      title = 'edit Title'
      detail = 'edit Detail'
      flush = 'error'

      subject
      fill_in 'Title', with: title
      fill_in 'Detail', with: detail
      fill_in 'Due date', with: Time.zone.yesterday.strftime("%Y-%m-%d")
      click_button 'Edit my task'

      expect(page).to have_current_path( task_path(task) )
      expect(page).to have_content(flush)
    end
  end

  describe 'Check the delete' do
    subject { visit task_path(task.id) }
    it 'Can delete tasks' do
      subject
      click_link 'DELETE'

      expect(page).to have_current_path( root_path )
      expect(page).to have_content('Delete Success')
    end
  end
end
