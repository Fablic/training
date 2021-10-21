# frozen_string_literal: true

require 'rails_helper'

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



  describe 'New task' do
    before { visit new_task_path() }

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
    before {
      visit root_path
      # move to Show
      page.all('#click_show')[0].click
    }

    it 'show display' do
      expect(page).to have_content 'Show task'
      expect(page).to have_field label_task_name, with: input_task_name
    end

    it "go to Task's list" do
      click_on "go to Task's list"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Edit task' do
    before {
      visit root_path
      # move to Edit
      page.all('#click_edit')[0].click
    }

    it 'show display' do
      expect(page).to have_content 'Update task'
      expect(page).to have_field label_task_name, with: input_task_name
    end

    it "go to Task's list" do
      click_on "go to Task's list"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Delete task' do
    before {
      visit root_path
    }

    it 'Destroy' do
      page.accept_confirm do
        page.all('#click_destroy')[0].click
      end

     expect(page).to have_content "Task's list"
     expect(page).to have_content "The task delete is complete."
    end
  end
end
