# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :system do
  include LoginHelper

  describe '#index' do
    context 'when user is not logged in' do
      before do
        visit root_path
      end

      it 'user should be redirected to login path' do
        expect(current_path).to eq login_path
      end
    end

    context 'when user is logged in' do
      before do
        @user_1 = create(:user)
        log_in(@user_1)
      end

      context "when task doesn't exist" do
        before do
          visit root_path
        end

        it "doesn't show any task" do
          expect(page).to have_selector('tbody tr', count: 0)
        end
      end

      context 'when one task exists' do
        before do
          @task_1 = create(:task, user: @user_1)
          visit root_path
        end

        it 'shows one task' do
          expect(current_path).to eq root_path
          expect(page).to have_content @task_1.title
          expect(page).to have_link @task_1.title, href: task_path(@task_1)
          expect(page).to have_button 'Delete'
        end
      end

      context 'when multiple tasks exist' do
        before do
          @tasks = create_list(:task, 3, user: @user_1)
          visit root_path
        end

        it 'shows task list in created_at descending order' do
          expect(page).to have_selector('tbody tr', count: 3)
          expect(page.all('tbody tr')[0]).to have_content(@tasks[2].title)
          expect(page.all('tbody tr')[1]).to have_content(@tasks[1].title)
          expect(page.all('tbody tr')[2]).to have_content(@tasks[0].title)
        end
      end

      context 'when task is filtered' do
        before do
          @tasks = create_list(:task, 5, user: @user_1)
          @label = create(:label, id: 1, name: 'work')
          visit root_path
        end

        it 'search by title' do
          fill_in 'query', with: 'ThisIsTitle3'
          click_on 'btn-search'

          expect(current_path).to eq root_path
          expect(page).to have_selector('tbody tr', count: 1)
        end

        it 'search by status' do
          # add extra items with various status
          create(:task, :status => Task.statuses[:status_not_started], user: @user_1)
          create_list(:task, 3, status: Task.statuses[:status_in_progress], user: @user_1)
          create_list(:task, 2, status: Task.statuses[:status_completed], user: @user_1)
          select I18n.t(:status_completed), from: 'search-status'
          click_on 'btn-search'

          expect(current_path).to eq root_path
          expect(page).to have_selector('tbody tr', count: 2)
        end

        it 'search by title and status' do
          # add extra items with various status
          create(:task, status: Task.statuses[:status_in_progress], user: @user_1)
          create(:task, status: Task.statuses[:status_completed], user: @user_1)
          create(:task, title: 'some random title', status: Task.statuses[:status_completed], user: @user_1)
          fill_in 'query', with: 'rand'
          select I18n.t(:status_completed), from: 'search-status'
          click_on 'btn-search'

          expect(current_path).to eq root_path
          expect(page).to have_selector('tbody tr', count: 1)
        end

        it 'search by label' do
          # add extra items with various status
          create(:task, title: 'working', user: @user_1)
          create(:task, user: @user_1)
          task_3 = create(:task, user: @user_1)
          create(:tasks_label, task_id: task_3.id, label_id: @label.id)

          fill_in 'query', with: @label.name
          click_on 'btn-search'

          expect(current_path).to eq root_path
          expect(page).to have_selector('tbody tr', count: 2)
        end
      end
    end
  end

  describe '#create' do
    context 'when submit a new task' do
      before do
        @user_1 = create(:user)
        log_in(@user_1)
        visit root_path
      end

      it 'creates a task successfully' do
        new_title = 'test title 1'
        new_description = 'test description 1'
        new_due_date_at = '2024-08-31'
        Task.statuses[:status_in_progress]
        fill_in 'task[title]', with: new_title
        fill_in 'task[description]', with: new_description
        fill_in 'task[due_date_at]', with: new_due_date_at
        select I18n.t(:status_in_progress), from: 'task[status]'
        click_on 'Create'

        # redirected back to root page
        expect(current_path).to eq root_path
        expect(page).to have_content '作成に成功しました'

        # make sure new task is there
        expect(page).to have_content new_title
        expect(page).to have_content new_due_date_at
        expect(page).to have_content Task.statuses[:status_in_progress]
      end

      it 'creates a task successfully w/ minimum fields' do
        new_title = 'test title 1'
        new_description = 'test description 1'
        fill_in 'task[title]', with: new_title
        fill_in 'task[description]', with: new_description
        click_on 'Create'

        # redirected back to root page
        expect(current_path).to eq root_path
        expect(page).to have_content '作成に成功しました'

        # make sure new task is there
        expect(page).to have_content new_title
        expect(page).to have_content Task.statuses[:status_not_started]
      end

      it 'failed to create a task due to blank title' do
        fill_in 'task[title]', with: ''
        click_on 'Create'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '作成に失敗しました'
      end

      it 'failed to create a task due to too long title' do
        fill_in 'task[title]', with: SecureRandom.alphanumeric(51)
        click_on 'Create'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '作成に失敗しました'
      end

      it 'failed to create a task due to too long description' do
        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[description]', with: SecureRandom.alphanumeric(501)
        click_on 'Create'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '作成に失敗しました'
      end

      it 'failed to create a task due to invalid due date' do
        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[due_date_at]', with: '2024/99/99'
        click_on 'Create'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '作成に失敗しました'
      end

      it 'failed to create a task due to invalid due date format' do
        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[due_date_at]', with: 'invalid_format!?'
        click_on 'Create'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '作成に失敗しました'
      end
    end
  end

  describe '#show' do
    before do
      @user_1 = create(:user)
      log_in(@user_1)
    end

    context 'when there is a valid task' do
      let!(:task_1) { create(:task, user: @user_1) }

      it 'shows details and edit link' do
        visit task_path(task_1)
        expect(page).to have_content task_1.title
        expect(page).to have_content task_1.description
        expect(page).to have_content Task.statuses[task_1.status]
        expect(page).to have_link 'Edit', href: edit_task_path(task_1)
        expect(current_path).to eq task_path(task_1)
        click_link 'Edit'
        expect(current_path).to eq edit_task_path(task_1)
      end
    end

    context 'when record not found' do
      it 'redirected to 404 error page due to not existing id' do
        visit task_path(99999)
        expect(current_path).to eq error_path(404)
      end

      it 'redirected to 404 error page due to invalid id format' do
        visit task_path('invalid_path')
        expect(current_path).to eq error_path(404)
      end
    end

    context "when the task is other users'" do
      before do
        @user_2 = create(:user)
        @task_2 = create(:task, user_id: @user_2.id)
        visit task_path(@task_2)
      end

      it 'redirected to 401 error page' do
        expect(current_path).to eq error_path(401)
      end
    end
  end

  describe '#edit' do
    before do
      @user_1 = create(:user)
      log_in(@user_1)
    end

    context 'when there is a valid task' do
      let!(:task_1) { create(:task, user: @user_1) }

      it 'shows edit form' do
        visit edit_task_path(task_1)
        expect(page).to have_field('task[title]', with: task_1.title)
        expect(page).to have_field('task[description]', with: task_1.description)
        expect(page).to have_field('task[due_date_at]', with: task_1.due_date_at)
        expect(page).to have_field('task[status]', with: Task.statuses[task_1.status])
        expect(page).to have_button 'Update'

        expect(current_path).to eq edit_task_path(task_1)
      end
    end

    context 'when record not found' do
      it 'redirected to root path due to not existing id' do
        visit edit_task_path(99_999)
        expect(current_path).to eq error_path(404)
      end

      it 'redirected to root path due to invalid id format' do
        visit edit_task_path('invalid_path')
        expect(current_path).to eq error_path(404)
      end
    end

    context "when the task is other users'" do
      before do
        @user_2 = create(:user)
        @task_2 = create(:task, user_id: @user_2.id)
        visit edit_task_path(@task_2)
      end

      it 'redirected to 401 error page' do
        expect(current_path).to eq error_path(401)
      end
    end
  end

  describe '#update' do
    before do
      @user_1 = create(:user)
      log_in(@user_1)
    end

    context 'when update a task' do
      let!(:task_1) { create(:task, user: @user_1) }

      # success case
      it 'updated a task successfully' do
        visit edit_task_path(task_1)

        # update a task
        updated_title = 'title 1 updated'
        updated_description = 'description 1 updated'
        updated_due_date_at = '2024/08/31'
        Task.statuses[:status_completed]
        fill_in 'task[title]', with: updated_title
        fill_in 'task[description]', with: updated_description
        fill_in 'task[due_date_at]', with: updated_due_date_at
        select I18n.t(:status_completed), from: 'task[status]'
        click_on 'Update'

        # redirected to root
        expect(current_path).to eq root_path
        expect(page).to have_content '更新に成功しました'

        # make sure the task was updated
        expect(page).to have_content updated_title
        expect(page).to have_content Task.statuses[:status_completed]
      end

      # failure cases
      it 'failed to update a task due to blank title' do
        visit edit_task_path(task_1)

        fill_in 'task[title]', with: ''
        click_on 'Update'

        expect(current_path).to eq task_path(task_1)
        expect(page).to have_content '更新に失敗しました'
      end

      it 'failed to update a task due to too long title' do
        visit edit_task_path(task_1)
        fill_in 'task[title]', with: SecureRandom.alphanumeric(51)
        fill_in 'task[description]', with: 'ThisIsDescription'
        click_on 'Update'

        expect(current_path).to eq task_path(task_1)
        expect(page).to have_content '更新に失敗しました'
      end

      it 'failed to update a task due to too long description' do
        visit edit_task_path(task_1)

        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[description]', with: SecureRandom.alphanumeric(501)
        click_on 'Update'
        expect(current_path).to eq task_path(task_1)
        expect(page).to have_content '更新に失敗しました'
      end

      it 'failed to update a task due to invalid due date' do
        visit edit_task_path(task_1)

        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[due_date_at]', with: '2024/99/99'
        click_on 'Update'
        expect(current_path).to eq task_path(task_1)
        expect(page).to have_content '更新に失敗しました'
      end

      it 'failed to update a task due to invalid due date format' do
        visit edit_task_path(task_1)

        fill_in 'task[title]', with: 'ThisIsTitle'
        fill_in 'task[due_date_at]', with: 'invalid_format!?'
        click_on 'Update'
        expect(current_path).to eq task_path(task_1)
        expect(page).to have_content '更新に失敗しました'
      end
    end
  end

  describe '#destroy' do
    before do
      @user_1 = create(:user)
      @task_1 = create(:task, user: @user_1)
      log_in(@user_1)
      visit root_path
    end

    context 'when delete a task' do
      it 'deletes a task successfully' do
        expect(page).to have_content @task_1.title
        click_on 'Delete'

        # redirected to root
        expect(current_path).to eq root_path
        expect(page).to have_content '削除に成功しました'

        # make sure the task was deleted
        expect(page).to have_no_content @task_1.title
        expect(page).to have_no_button 'Delete'
      end
    end
  end

  describe '#add_labels' do
    before do
      @user_1 = create(:user)
      create(:label, id: 1, name: 'work')
      create(:label, id: 2, name: 'hobby')
      create(:label, id: 3, name: 'baseball')

      log_in(@user_1)
      visit root_path
    end

    context 'when creating a task with existing label' do
      it 'create a task with labels successfully' do
        new_title = 'test title 1'
        Task.statuses[:status_in_progress]
        fill_in 'task[title]', with: new_title
        fill_in 'task[labels]', with: 'work hobby game food ramen'
        click_on 'Create'

        # redirected back to root page
        expect(current_path).to eq root_path
        expect(page).to have_content '作成に成功しました'

        # make sure new task is there
        expect(page).to have_content new_title
      end
    end
  end

end
