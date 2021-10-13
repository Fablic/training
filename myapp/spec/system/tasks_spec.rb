# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  describe 'Index Page' do
    let!(:task_list) { create_list(:task, 4) }

    before { visit root_path }

    context 'when display task list' do
      it 'display task list title, success' do
        expect(page).to have_content task_list.first.title
      end

      it 'display task list created_at, success' do
        expect(page).to have_content I18n.l task_list.first.created_at
      end

      it 'display task list due_date, success' do
        expect(page).to have_content I18n.l task_list.first.due_date
      end
    end

    context 'when open list page' do
      it 'default sort by created_at order by desc, success' do
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.last.created_at
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.first.created_at
      end
    end

    context 'when push link to sort by due_date asc' do
      it 'sort by due_date asc, success' do
        click_on '期日で並び替え' # 1回押すと昇順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.first.due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.last.due_date
      end
    end

    context 'when push link to sort by due_date desc' do
      it 'sort by due_date order by desc, success' do
        click_on '期日で並び替え' # 1回押すと昇順
        click_on '期日で並び替え' # 2回押すと降順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.last.due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.first.due_date
      end
    end

    context 'when push create button' do
      it 'move to create page, success' do
        click_on '作成'
        expect(page).to have_content 'Tasks#new'
      end
    end

    context 'when push edit button' do
      it 'move to edit page, success' do
        all('table tr')[1].click_on '編集'
        expect(page).to have_content 'Tasks#edit'
      end
    end

    context 'when push detail button' do
      it 'move to detail page, success' do
        find('tr:nth-child(2)').click_on task_list.last.title
        expect(page).to have_content 'Tasks#detail'
      end
    end
  end

  describe 'Create Page' do
    before { visit new_task_path }

    context 'when create task' do
      # https://github.com/faker-ruby/faker#usage
      it 'create task, success' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
        fill_in 'task[due_date]',    with: Faker::Time.forward(days: 23, period: :morning)
        click_button '送信'
        expect(page).to have_content 'Successfully created'
      end
    end

    context 'when push back button' do
      it 'back to index page, success' do
        click_on '戻る'
        expect(page).to have_content 'Tasks#list'
      end
    end
  end

  describe 'Edit Page' do
    let!(:task) { create(:task) }

    before { visit edit_task_path(task.id) }

    context 'when list task contents' do
      it 'list task contents title, success' do
        expect(page).to have_field '件名', with: task.title
      end

      it 'list task contents description, success' do
        expect(page).to have_field '詳細', with: task.description
      end

      it 'list task contents due_date, success' do
        expect(page).to have_field '期日', with: task.due_date.strftime('%Y-%m-%dT%H:%M:%S')
      end
    end

    context 'when edit and resister task' do
      it 'edit and resister task, success' do
        fill_in 'task[title]',       with: 'title for edit'
        fill_in 'task[description]', with: 'description for edit'
        fill_in 'task[due_date]',    with: Faker::Time.forward(days: 23, period: :morning)
        click_button '送信'
        expect(page).to have_content 'Successfully updated'
      end
    end
  end

  describe 'Detail Page' do
    let(:task) { create(:task) }

    before { visit task_path(task.id) }

    context 'when open list page' do
      it 'list task contents title, success' do
        expect(page).to have_content task.title
      end

      it 'list task contents description, success' do
        expect(page).to have_content task.description
      end

      it 'list task contents created_at, success' do
        expect(page).to have_content taskcreated_at
      end

      it 'list task contents due_date, success' do
        expect(page).to have_content task.due_date
      end
    end

    context 'when push back button' do
      it 'move to list page, success' do
        click_on '戻る'
        expect(page).to have_content 'Tasks#list'
      end
    end

    context 'when push edit button' do
      it 'move to edit page, success' do
        click_on '編集'
        expect(page).to have_content 'Tasks#edit'
      end
    end
  end
end
