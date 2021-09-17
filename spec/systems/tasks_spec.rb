require 'rails_helper'

RSpec.describe Task, type: :system do
  let!(:task) { create(:task) }
  describe 'index task' do
    it 'visit index page' do
      visit root_path
      expect(page).to have_content 'Task Index'
      expect(page).to have_content 'task 1'
    end
  end

  describe 'create task' do
    before { visit new_task_path }

    it 'visit new task page' do
      expect(page).to have_content 'New Task'
    end

    context 'valid form' do
      before do
        fill_in 'task_name', with: 'task 2'
        fill_in 'task_description', with: 'task 2 description'
        select 'medium', from: 'task_priority'
      end
      it "success" do
        click_button 'Create Task'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content 'task 2'
      end
    end

    context 'invalid form' do
      before do
        fill_in 'task_name', with: nil
      end
      it "validate fail" do
        click_button 'Create Task'
        expect(page).to have_content "Name can't be blank"
      end
    end
  end

  describe 'update task' do
    before { visit edit_task_path(task) }

    it 'visit new task page' do
      expect(page).to have_content 'Editing Task'
    end

    context 'valid form' do
      before do
        fill_in 'task_name', with: 'task 1 updated'
        fill_in 'task_description', with: 'task 1 description updated'
        select 'high', from: 'task_priority'
      end
      it "success" do
        click_button 'Update Task'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Task was successfully updated.'
        expect(task.reload.name).to eq 'task 1 updated'
        expect(task.reload.description).to eq 'task 1 description updated'
        expect(task.reload.priority).to eq 'high'
      end
    end

    context 'invalid form' do
      before do
        fill_in 'task_name', with: 'a' * 256
      end
      it "validate fail" do
        click_button 'Update Task'
        expect(page).to have_content 'Name is too long'
      end
    end
  end

  describe 'show task' do
    it 'visit show task page' do
      visit task_path(task)
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'task 1'
      expect(page).to have_content 'task 1 description'
      expect(page).to have_content 'low'
    end
  end

  describe 'destroy task' do
    before { visit root_path }
    it 'success' do
      click_link 'Destroy', match: :first
      expect {
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure?'
        page.driver.browser.switch_to.alert.accept
      }.to change{ Task.count }.by(0)
      expect(page).to have_content 'Task was successfully deleted.'
    end
  end
end
