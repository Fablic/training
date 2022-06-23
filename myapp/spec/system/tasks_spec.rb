# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :system do
  before do
    create(:user)
  end

  describe '#index' do
    before do
      visit root_path
    end

    it 'display default item' do
      expect(page).to have_link 'Add Task'
    end

    it 'go to New Task page' do
      click_on 'Add Task'
      expect(current_path).to eq new_task_path
    end

    context 'when user has tasks' do
      before do
        create(:task)
        visit current_path
      end

      it "return user's task" do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_link '散歩'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
      end
    end

  end

  describe '#show' do
    let(:task) { create(:task) }

    before do
      visit task_path(task)
    end

    it 'return task info' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_content task.name
      expect(page).to have_content task.description
      expect(page).to have_content task.priority
      expect(page).to have_content task.limit
    end

    context 'when user click Edit' do
      it 'return edit task form' do
        click_on 'Edit'
        expect(page).to have_current_path edit_task_path(task), ignore_query: true
      end
    end

    context 'when user click Delete' do
      it 'delete task' do
        expect {
          click_on 'Delete'
        }.to change { Task.count }.by(-1)
      end

      it 'display delete success message' do
        click_on 'Delete'
        expect(page).to have_content 'delete success'
      end
    end

    context 'when user click Home' do
      it 'go to roog page' do
        click_on 'Home'
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#new' do
    before do
      visit new_task_path
    end

    context 'when user go to this page' do
      it 'display blank task form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'Task title'
        expect(page).to have_field 'Description'
        expect(page).to have_field 'Limit'
        expect(page).to have_field 'Status'
        expect(page).to have_field 'Priority'
      end
    end
  end

  describe '#edit' do
    let(:task) { create(:task) }

    before do
      visit edit_task_path(task)
    end

    context 'when user go to this page' do
      it 'display task form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'Task title', with: task.name
        expect(page).to have_field 'Description', with: task.description
        expect(page).to have_field 'Limit', with: task.limit
        expect(page).to have_field 'Status', with: task.status
        expect(page).to have_field 'Priority', with: task.priority
      end
    end
  end

  describe '#create' do
    before do
      visit new_task_path
    end

    context 'when user go to Add task page' do
      it 'display brank form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'Task title'
        expect(page).to have_field 'Description'
        expect(page).to have_field 'Limit'
        expect(page).to have_field 'Status'
        expect(page).to have_field 'Priority'
      end
    end

    context 'when user input task' do
      before do
        fill_in 'Task title', with: '散歩'
        fill_in 'Description', with: '多摩川を歩く'
        fill_in 'Limit', with: '2022-06-20'
        select 'TODO', from: 'Status'
        select 'Low', from: 'Priority'
      end

      it 'display input task info' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'Task title', with: '散歩'
        expect(page).to have_field 'Description', with: '多摩川を歩く'
        expect(page).to have_field 'Limit', with: '2022-06-20'
        expect(page).to have_field 'Status', with: 'TODO'
        expect(page).to have_field 'Priority', with: 'Low'
      end

      context 'when user click "Create Task" button' do
        it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
          click_on 'Create Task'
          expect(page).to have_content '散歩'
          expect(page).to have_content '多摩川を歩く'
          expect(page).to have_content '2022-06-20'
          expect(page).to have_content 'TODO'
          expect(page).to have_content 'Low'
        end
      end
    end
  end

  describe '#update' do
    let(:task) { create(:task) }

    before do
      visit edit_task_path(task)
    end

    context 'when user edit task form correctly' do
      before do
        fill_in 'Task title', with: '運動'
        fill_in 'Description', with: '多摩川を走る'
        fill_in 'Limit', with: '2022-06-20'
        select 'IN PROGRESS', from: 'Status'
        select 'Normal', from: 'Priority'
      end

      it 'display new task info' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'Task title', with: '運動'
        expect(page).to have_field 'Description', with: '多摩川を走る'
        expect(page).to have_field 'Limit', with: '2022-06-20'
        expect(page).to have_field 'Status', with: 'IN_PROGRESS'
        expect(page).to have_field 'Priority', with: 'Normal'
      end

      context 'when user click "Update Task" button' do
        it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
          click_on 'Update Task'
          expect(page).to have_content '運動'
          expect(page).to have_content '多摩川を走る'
          expect(page).to have_content '2022-06-20'
          expect(page).to have_content 'IN_PROGRESS'
          expect(page).to have_content 'Normal'
          expect(page).to have_content 'Edit success'
        end
      end
    end

    context 'when user edit task form incorrectly' do
      before do
        fill_in 'Task title', with: ''
        fill_in 'Description', with: '多摩川を走る'
        fill_in 'Limit', with: '2022-06-20'
        select 'IN PROGRESS', from: 'Status'
        select 'Normal', from: 'Priority'
      end

      it 'unable to complete editing (because name is blank)' do
        click_on 'Update Task'
        expect(page).to have_content 'Edit failed'
      end
    end
  end

  describe '#destroy' do
    before do
      create(:task)
      visit root_path
    end

    context 'when the deletion process success' do
      it 'delete task' do  # rubocop:disable RSpec/MultipleExpectations
        expect {
          click_on 'Delete'
        }.to change { Task.count }.by(-1)
      end

      it 'display delete success message' do
        click_on 'Delete'
        expect(page).to have_content 'delete success'
      end
    end

    context 'when the deletion process fails ' do
      before do
        allow_any_instance_of(Task).to receive(:destroy).and_return(false)
      end

      it 'display delete failed message' do
        click_on 'Delete'
        expect(page).to have_content 'Delete failed'
      end
    end
  end
end
