# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  let!(:user) { create(:user) }
  let!(:task_list) { create_list(:task, 5) }

  before do
    visit login_path
    fill_in 'session_login_id', with: user.login_id
    fill_in 'session_password', with: user.password
    click_button I18n.t('login.new.login')
  end

  describe 'New task' do
    before { visit new_task_path() }

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
          select(value = 'done', from: 'task_status')
          fill_in 'task_priority', with: 1
          fill_in 'task_start_date', with: Time.zone.yesterday.strftime('%Y-%m-%d')
          fill_in 'task_end_date', with: Time.zone.now.strftime('%Y-%m-%d')

          click_button I18n.t('helpers.submit.create')

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
    before {
      visit root_path
      # move to Show
      page.all('#click_show')[0].click
    }

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
    end
  end

  describe 'Edit task' do
    before {
      visit root_path
      # move to Edit
      page.all('#click_edit')[0].click
    }

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

          click_button I18n.t('helpers.submit.update')
          visit root_path

          expect(page).to have_content 'update_task_name'
        end
      end
    end
  end

  describe 'Delete task' do
    before {
      visit root_path
    }

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
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(2)')).to have_content I18n.l task_list[1].start_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(3)')).to have_content I18n.l task_list[2].start_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content I18n.l task_list[3].start_date
      end
    end

    context 'when click link to sort by end_date asc' do
      it 'sort success' do
        click_on I18n.t('tasks.common.end_date') # 1回押す(昇順)
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content I18n.l task_list[4].end_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content I18n.l task_list[1].end_date
      end
    end

    context 'when click link to sort by end_date desc' do
      it 'sort success' do
        click_on I18n.t('tasks.common.end_date') # 1回押す(昇順)
        click_on I18n.t('tasks.common.end_date') # 2回押す(降順)
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content I18n.l task_list[0].end_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content I18n.l task_list[3].end_date
      end
    end
  end

  describe 'search by condition' do
    before { visit root_path }

    let(:task_name_origin_prefix) { 'Task_name_' }
    let(:task_name) { 'search_keyword' }
    let(:status) { 'inProgress' }
    let!(:task_search) { create(:task, task_name: task_name, status: status) }

    context 'when search all' do
      it 'search success' do
        click_on I18n.t('helpers.submit.search')

        expect(find('#task_list > tbody:nth-child(2)')).to have_content task_name
        # factories.fasks.rbにセットされたデータも検索できること
        expect(find('#task_list > tbody:nth-child(2)')).to have_content task_name_origin_prefix
      end
    end

    context 'when search by task_name' do
      it 'search success' do
        fill_in 'search[task_name_cont]', with: 'search_keyword'
        click_on I18n.t('helpers.submit.search')

        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_name
        # factories.fasks.rbにセットされたデータは検索できないこと
        expect(find('#task_list > tbody:nth-child(2)')).not_to have_content task_name_origin_prefix
      end
    end

    context 'when search by status' do
      it 'search success' do
        select(value = 'inProgress', from: 'search_status_eq')
        click_on I18n.t('helpers.submit.search')

        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_name
        # factories.fasks.rbにセットされたデータは検索できないこと
        expect(find('#task_list > tbody:nth-child(2)')).not_to have_content task_name_origin_prefix
      end
    end

    context 'when search by task_name and status' do
      it 'search success' do
        fill_in 'search[task_name_cont]', with: 'search_keyword'
        select(value = 'inProgress', from: 'search_status_eq')
        click_on I18n.t('helpers.submit.search')

        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_name
        # factories.fasks.rbにセットされたデータは検索できないこと
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).not_to have_content task_name_origin_prefix
      end
    end
  end
end
