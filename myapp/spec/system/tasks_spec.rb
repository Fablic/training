# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:tasks) { FactoryBot.create_list(:task, 2, user: user) }
  let!(:query_params) {
    {
      status: tasks.last.status,
      title: tasks.last.title.slice(5, 5),
    }
  }

  before { login_as(user) }

  describe '#index' do
    example 'all tasks are displayed.' do
      expect(page).to have_content tasks.last.title
    end

    context 'with filtering params' do
      before {
        visit root_path query_params
      }

      example 'filtered task is displayed.' do
        expect(page).to have_no_content tasks.first.title
      end
    end

    example 'one task can be shown.' do
      click_link tasks.first.title
      expect(page).to have_current_path task_path(tasks.first)
    end

    example 'a task can be deleted.' do
      expect {
        page.first('.destroy').click
      }.to change(Task, :count).by(-1)
    end

    context 'when sorting by created_at,' do
      example 'tasks can be sorted in ascending direcction.' do
        visit root_path(sort: 'created_at', direction: 'asc')
        expect(page.body.index(tasks.first.title)).to be < page.body.index(tasks.last.title)
      end

      example 'tasks can be sorted in descending direcction.' do
        visit root_path(sort: 'created_at', direction: 'desc')
        expect(page.body.index(tasks.first.title)).to be > page.body.index(tasks.last.title)
      end
    end

    context 'when sorting by expires_at,' do
      example 'tasks can be sorted in ascending direcction.' do
        visit root_path(sort: 'expires_at', direction: 'asc')
        expect(page.body.index(tasks.first.title)).to be < page.body.index(tasks.last.title)
      end

      example 'tasks can be sorted in descending direcction.' do
        visit root_path(sort: 'expires_at', direction: 'desc')
        expect(page.body.index(tasks.first.title)).to be > page.body.index(tasks.last.title)
      end
    end
  end

  describe '#new' do
    before do
      visit new_task_path()

      # 全て入力しておく
      fill_in 'task[title]', with: 'spec test title'
      fill_in 'task[description]', with: 'spec test description'
      select I18n.t('enums.task.status.todo'), from: I18n.t('activerecord.attributes.task.status')
      select I18n.t('enums.task.priority.low'), from: I18n.t('activerecord.attributes.task.priority')
      fill_in 'task[expires_at]', with: '2021-11-19T10:58'
    end

    example 'A task can be registered.' do
      find('[name=commit]').click
      expect(page).to have_content I18n.t('pages.tasks.flash.registered')
    end

    describe 'Title' do
      example 'less or euqal than 255' do
        # タイトルを空にする
        fill_in 'task[title]', with: Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{256}')
        find('[name=commit]').click
        expect(page).to have_content 'タイトルは255文字以内で入力してください'
      end

      example 'is required' do
        # タイトルを空にする
        fill_in 'task[title]', with: ''
        find('[name=commit]').click
        expect(page).to have_content 'タイトルを入力してください'
      end
    end

    describe 'priority' do
      example 'A task can be registered without status.' do
        select '', from: I18n.t('activerecord.attributes.task.priority')
        find('[name=commit]').click

        expect(page).to have_content I18n.t('pages.tasks.flash.registered')
      end
    end

    describe 'status' do
      example 'A task can be registered without status.' do
        select '', from: I18n.t('activerecord.attributes.task.status')
        find('[name=commit]').click

        expect(page).to have_content I18n.t('pages.tasks.flash.registered')
      end
    end
  end

  describe '#edit' do
    let!(:task) { FactoryBot.create(:task) }
    let!(:params) {
      {
        title: 'title for edit',
        description: 'description for edit',
        status: I18n.t('enums.task.status.done'),
        priority: I18n.t('enums.task.priority.high'),
        expires_at: Time.zone.now,
      }
    }

    example 'the page can be shown.' do
      visit edit_task_path(task)
      expect(page).to have_field 'task[title]', with: task.title
    end

    example 'Title can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:title]
      find('[name=commit]').click

      expect(page).to have_content params[:title]
    end

    example 'Description can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[description]', with: params[:description]
      find('[name=commit]').click

      expect(page).to have_content params[:description]
    end

    example 'Status can be updated.' do
      visit edit_task_path(task)
      select params[:status], from: I18n.t('activerecord.attributes.task.status')
      find('[name=commit]').click

      expect(page).to have_content params[:status]
    end

    example 'Priority can be updated.' do
      visit edit_task_path(task)
      select params[:priority], from: I18n.t('activerecord.attributes.task.priority')
      find('[name=commit]').click

      expect(page).to have_content params[:priority]
    end

    example 'Expires_at can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[expires_at]', with: params[:expires_at]
      find('[name=commit]').click

      expect(page).to have_content params[:expires_at]
    end
  end

  describe '#destroy' do
    let!(:task) { FactoryBot.create(:task) }

    example 'a task can be deleted.' do
      visit task_path(task)
      click_link I18n.t('common.destroy')
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'without login' do
    example 'redirect to login_path' do
      visit logout_path
      visit tasks_path
      expect(page).to have_current_path login_path
    end
  end
end
