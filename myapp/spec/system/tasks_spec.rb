# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
RSpec.describe 'tasks', type: :system do
  let!(:task_list) { create_list(:task, 5) }
=======
RSpec.describe 'Tasks', type: :system do  
  # 画面ラベル名
  let(:label_task_name) { 'Task name' }
  let(:label_description) { 'Description' }
  let(:label_status) { 'Status' }
  let(:label_priority) { 'Priority' }
  let(:label_label) { 'Label' }
  let(:label_start_date) { 'Start date' }
  let(:label_end_date) { 'End date' }
  # 項目設定値
  let(:input_task_name) { 'input Task' }
  let(:input_description) { 'input Description' }
  let(:input_status) { 'todo' }
  let(:input_priority) { 1 }
  let(:input_label) { 'input Label' }
  let(:input_start_date) { Time.zone.yesterday.strftime('%Y-%m-%d') }
  let(:input_end_date) { Time.zone.now.strftime('%Y-%m-%d') }


>>>>>>> origin/ichinoseken

  describe 'New task' do
    before { visit new_task_path() }

<<<<<<< HEAD
    context 'Check each function on the new registration screen.' do
      context 'Screen display confirmation' do
        it 'show display' do
          expect(page).to have_content I18n.t('tasks.new.title')
          expect(page).to have_title 'Myapp'
          expect(page).to have_content I18n.t('tasks.common.task_name')
          expect(page).to have_content I18n.t('tasks.common.description') 
          expect(page).to have_content I18n.t('tasks.common.status')
          expect(page).to have_content I18n.t('tasks.common.priority')
          expect(page).to have_content I18n.t('tasks.common.label') 
          expect(page).to have_content I18n.t('tasks.common.start_date')
          expect(page).to have_content I18n.t('tasks.common.end_date')
        end
      end

      context 'Registration Confirmation' do
        it 'registration' do
          fill_in 'task_task_name', with: 'input Task'
          fill_in 'task_description', with: 'input Description'
          fill_in 'task_status', with: 'todo'
          fill_in 'task_priority', with: 1
          fill_in 'task_label', with: 'input Label'
          fill_in 'task_start_date', with: Time.zone.yesterday.strftime('%Y-%m-%d') 
          fill_in 'task_end_date', with: Time.zone.now.strftime('%Y-%m-%d')
    
          click_button 'Create Task'
    
          expect(page).to have_current_path root_path, ignore_query: true
          expect(page).to have_content I18n.t('tasks.flash.complete_task_registration')
        end
      end

      context 'Screen transition confirmation' do
        it "go to Task's list" do
          click_on I18n.t('tasks.common.move_task_list')
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end
    end 
  end

  describe 'Show task' do

=======
    it 'show display' do
      expect(page).to have_content 'Registe task'
      expect(page).to have_title 'Myapp'
      expect(page).to have_content 'Task name'
      expect(page).to have_content 'Description'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Priority'
      expect(page).to have_content 'Label'
      expect(page).to have_content 'Start date'
      expect(page).to have_content 'End date'
    end

    it 'registration' do
      fill_in label_task_name, with: input_task_name
      fill_in label_description, with: input_description
      fill_in label_status, with: input_status
      fill_in label_priority, with: input_priority
      fill_in label_label, with: input_label
      fill_in label_start_date, with: input_start_date
      fill_in label_end_date, with: input_end_date

      click_button 'Create Task'

      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_content 'The task registration is complete.'
    end

    it "go to Task's list" do
      click_on "go to Task's list"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Index' do
    before { visit root_path }

    it 'show list' do
      expect(page).to have_content "Task's list"
      expect(page).to have_title 'Myapp'
      expect(page).to have_content 'id'
      expect(page).to have_content 'タスク名'
      expect(page).to have_content 'ステータス'
      expect(page).to have_content 'ラベル'
      expect(page).to have_content '開始日時'
      expect(page).to have_content '終了日時'
    end

    it 'Go to registration page' do
      click_on 'Create New Task'
      expect(page).to have_content 'Registe task'
    end

    it 'Go to Show page' do
      page.all('#click_show')[0].click
      expect(page).to have_content 'Show task'
    end

    it 'Go to Edit page' do
      page.all('#click_edit')[0].click
      expect(page).to have_content 'Update task'
    end

    it 'Show dialog of delete' do
      page.dismiss_confirm('Are you sure you want to delete it?') do
        page.all('#click_destroy')[0].click
      end
      expect(page).to have_content "Task's list"
    end
  end

  describe 'Show task' do
>>>>>>> origin/ichinoseken
    before {
      visit root_path
      # move to Show
      page.all('#click_show')[0].click
    }

<<<<<<< HEAD
    context 'Check each function on the show screen.' do
      context 'Screen display confirmation' do
        it 'show display' do
          expect(page).to have_content I18n.t('tasks.show.title')
        end
      end

      context 'Screen transition confirmation' do
        it "go to Task's list" do
          click_on I18n.t('tasks.common.move_task_list')
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end
=======
    it 'show display' do
      expect(page).to have_content 'Show task'
      expect(page).to have_field label_task_name, with: input_task_name
    end

    it "go to Task's list" do
      click_on "go to Task's list"
      expect(page).to have_current_path root_path, ignore_query: true
>>>>>>> origin/ichinoseken
    end
  end

  describe 'Edit task' do
    before {
      visit root_path
      # move to Edit
      page.all('#click_edit')[0].click
    }

<<<<<<< HEAD
    context 'Check each function on the edit screen.' do
      context 'Screen display confirmation' do
        it 'show display' do
          expect(page).to have_content I18n.t('tasks.edit.title')\
        end
      end

      context 'Screen transition confirmation' do
        it "go to Task's list" do
          click_on I18n.t('tasks.common.move_task_list')
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end

      context 'Update Confirmation' do     
        it 'update' do
          fill_in 'task_task_name', with: 'update_task_name'

          click_button 'Update Task'
          visit root_path
    
          expect(page).to have_content 'update_task_name'
        end
      end
=======
    it 'show display' do
      expect(page).to have_content 'Update task'
      expect(page).to have_field label_task_name, with: input_task_name
    end

    it "go to Task's list" do
      click_on "go to Task's list"
      expect(page).to have_current_path root_path, ignore_query: true
>>>>>>> origin/ichinoseken
    end
  end

  describe 'Delete task' do
<<<<<<< HEAD

=======
>>>>>>> origin/ichinoseken
    before {
      visit root_path
    }

<<<<<<< HEAD
    context 'Check each function on the delete screen.' do
      context 'Screen display confirmation' do
        it 'Destroy' do
          page.all('#click_destroy')[0].click
          
          expect(page).to have_content I18n.t('tasks.index.title')
          expect(page).to have_content I18n.t('tasks.flash.complete_task_destroy')
        end
      end
    end
  end

  describe 'Index' do

    before { visit root_path }

    context 'Check each function on the index screen.' do
      context 'Screen display confirmation' do
        it 'table colums check' do
          within('#task_list') do
            expect(page).to have_content I18n.t('tasks.common.id')
            expect(page).to have_content I18n.t('tasks.common.task_name')
            expect(page).to have_content I18n.t('tasks.common.status')
            expect(page).to have_content I18n.t('tasks.common.label')
            expect(page).to have_content I18n.t('tasks.common.priority')
            expect(page).to have_content I18n.t('tasks.common.start_date')
            expect(page).to have_content I18n.t('tasks.common.end_date')
          end
        end
      end

      context 'Screen transition confirmation' do
        it 'Go to registration page' do
          click_on I18n.t('tasks.index.move_new_task')
          expect(page).to have_content I18n.t('tasks.new.title')
        end

        it 'Go to Show page' do
          #byebug
          expect(page).to have_content task_list[0].task_name
          page.all('#click_show')[0].click
          expect(page).to have_content I18n.t('tasks.show.title')
        end

        it 'Go to Edit page' do
          expect(page).to have_content task_list[0].task_name
          page.all('#click_edit')[0].click
          expect(page).to have_content I18n.t('tasks.edit.title')
        end

        it 'Show dialog of delete' do
          expect(page).to have_content task_list[0].task_name
          page.all('#click_destroy')[0].click
          expect(page).to have_content I18n.t('tasks.index.title')
        end
      end
    end
  end

  describe 'sort function' do
    before { visit root_path }

    context 'when open list page(sort by created_at order by desc)' do
      it 'order success' do
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list[3].end_date
        expect(find('tr:nth-child(3)')).to have_content I18n.l task_list[2].end_date
        expect(find('tr:nth-child(4)')).to have_content I18n.l task_list[1].end_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list[0].end_date
      end
=======
    it 'Destroy' do
      page.accept_confirm do
        page.all('#click_destroy')[0].click
      end

     expect(page).to have_content "Task's list"
     expect(page).to have_content "The task delete is complete."
>>>>>>> origin/ichinoseken
    end
  end
end
