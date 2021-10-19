require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:task_list) { Task.all() }

  describe 'Index' do
    before { visit root_path }

    it 'show list' do
      expect(page).to have_title "Myapp"
      expect(page).to have_content 'id'
      expect(page).to have_content 'タスク名'
      expect(page).to have_content 'ステータス'
      expect(page).to have_content 'ラベル'
      expect(page).to have_content '開始日時'
      expect(page).to have_content '終了日時'
    end

    it "Go to registration page" do
      click_on 'Create New Task'
      expect(page).to have_content 'Registe task'
    end

    it "Go to Show page" do
      all(tbody td)[1].click_on "Show"
      expect(page).to have_content "Show page"
    end

    it "Go to Edit page" do
      all(tbody td)[1].click_on "Edit"
      expect(page).to have_content 'Update task'
    end
  
    it "Show dialog of delete" do
      all(tbody td)[1].click_on "Destroy"
      expect(page).to have_content 'Are you sure you want to delete it?'
    end
  end

  describe 'New task' do
    before { visit new_task_path() }

    it 'show' do
      expect(page).to have_title "Myapp"
      expect(page).to have_content 'Task name'
      expect(page).to have_content 'Description'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Priority'
      expect(page).to have_content 'Label'
      expect(page).to have_content 'Start date'
      expect(page).to have_content 'End date'
    end

    it 'show list' do
      expect(page).to have_title "Myapp"
      expect(page).to have_content(task_list.last.title)
    end

  end

end
