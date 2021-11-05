# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'Name', with: user.name
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  describe '#index' do
    let!(:task_list) { create_list(:task, 4, user: user) }

    before { visit root_path }

    context 'when open index page' do
      context 'with displayed title' do
        it 'display success' do
          expect(page).to have_content task_list.first.title
        end
      end

      context 'with displayed created_at' do
        it 'display success' do
          expect(page).to have_content I18n.l task_list.first.created_at
        end
      end

      context 'with displayed due_date' do
        it 'display success' do
          expect(page).to have_content I18n.l task_list.first.due_date
        end
      end
    end

    context 'when click create button' do
      it 'move success' do
        click_on '作成'
        expect(page).to have_content 'Tasks#new'
      end
    end

    context 'when click edit button' do
      it 'move success' do
        all('table tr')[1].click_on '編集'
        expect(page).to have_content 'Tasks#edit'
      end
    end

    context 'when click detail button' do
      it 'move success' do
        find('tr:nth-child(2)').click_on task_list.last.title
        expect(page).to have_content 'Tasks#detail'
      end
    end
  end

  describe '#create' do
    before { visit new_task_path }

    context 'when create task' do
      it 'create success' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
        fill_in 'task[due_date]',    with: Faker::Time.forward(days: 23, period: :morning)
        click_button '送信' 
        expect(page).to have_content 'Successfully created'
      end
    end

    context 'when click back button' do
      it 'back to index page, success' do
        click_on '戻る'
        expect(page).to have_content 'Tasks#list'
      end
    end
  end

  describe '#edit' do
    let!(:task) { create(:task, user: user) }

    context 'when open edit page' do
      context 'with displayed title' do
        it 'display success' do
          visit edit_task_path(task.id)
          expect(page).to have_field '件名', with: task.title
        end
      end

      context 'with displayed created_at' do
        it 'display success' do
          visit edit_task_path(task.id)
          expect(page).to have_field '詳細', with: task.description
        end
      end

      context 'with displayed due_date' do
        it 'display success' do
          visit edit_task_path(task.id)
          expect(page).to have_field '期日', with: task.due_date.strftime('%Y-%m-%dT%H:%M:%S')
        end
      end
    end

    context 'when edit and resister task' do
      it 'edit and resister task, success' do
        visit edit_task_path(task.id)
        fill_in 'task[title]',       with: 'title for edit'
        fill_in 'task[description]', with: 'description for edit'
        fill_in 'task[due_date]',    with: Faker::Time.forward(days: 23, period: :morning)
        click_button '送信'
        expect(page).to have_content 'Successfully updated'
      end
    end
  end

  describe '#show' do
    let(:task) { create(:task, user: user) }

    before { visit task_path(task.id) }

    context 'when open list page' do
      context 'with displayed title' do
        it 'display success' do
          expect(page).to have_content task.title
        end
      end

      context 'with displayed description' do
        it 'display success' do
          expect(page).to have_content task.description
        end
      end

      context 'with displayed created_at' do
        it 'display success' do
          expect(page).to have_content task.created_at.strftime('%Y/%m/%d %H:%M:%S')
        end
      end

      context 'with displayed due_date' do
        it 'display success' do
          expect(page).to have_content task.due_date.strftime('%Y/%m/%d %H:%M:%S')
        end
      end
    end

    context 'when click back button' do
      it 'move success' do
        click_on '戻る'
        expect(page).to have_content 'Tasks#list'
      end
    end

    context 'when click edit button' do
      it 'move success' do
        click_on '編集'
        expect(page).to have_content 'Tasks#edit'
      end
    end
  end

  describe 'search with status' do
    before { visit root_path }

    let!(:task_not_started) { create(:task, status: 0, user: user) }
    let!(:task_in_progress) { create(:task, status: 1, user: user) }
    let!(:task_completed)   { create(:task, status: 2, user: user) }

    context 'when search by not_selected' do
      it 'search by not_selected, success' do
        select 'Select status', from: 'q_status_eq'
        click_on '検索'
        expect(find('tr:nth-child(4)')).to have_content '未着手'
        expect(find('tr:nth-child(3)')).to have_content '進行中'
        expect(find('tr:nth-child(2)')).to have_content '完了'
      end
    end

    context 'when search by not_satrted' do
      it 'search by not_satrted, success' do
        select '未着手', from: 'q_status_eq'
        click_on '検索'
        expect(find('tr:nth-child(2)')).to have_content '未着手'
        expect(find('tr:nth-child(2)')).not_to have_content '進行中'
        expect(find('tr:nth-child(2)')).not_to have_content '完了'
      end
    end

    context 'when search by in_progress' do
      it 'search by in_progress, success' do
        select '進行中', from: 'q_status_eq'
        click_on '検索'
        expect(find('tr:nth-child(2)')).not_to have_content '未着手'
        expect(find('tr:nth-child(2)')).to have_content '進行中'
        expect(find('tr:nth-child(2)')).not_to have_content '完了'
      end
    end

    context 'when search by completed' do
      it 'search by completed, success' do
        select '完了', from: 'q_status_eq'
        click_on '検索'
        expect(find('tr:nth-child(2)')).not_to have_content '未着手'
        expect(find('tr:nth-child(2)')).not_to have_content '進行中'
        expect(find('tr:nth-child(2)')).to have_content '完了'
      end
    end
  end

  describe 'search with title' do
    before { visit root_path }

    let!(:task_not_started) { create(:task, title: 'first', user: user) }
    let!(:task_in_progress) { create(:task, title: 'last', user: user) }

    context 'when search by first' do
      it 'search success' do
        fill_in 'q[title_cont]', with: 'first'
        click_on '検索'
        expect(find('tr:nth-child(2)')).to have_content 'first'
        expect(find('tr:nth-child(2)')).not_to have_content 'last'
      end
    end

    context 'when search by last' do
      it 'search success' do
        fill_in 'q[title_cont]', with: 'last'
        click_on '検索'
        expect(find('tr:nth-child(2)')).to have_content 'last'
        expect(find('tr:nth-child(2)')).not_to have_content 'first'
      end
    end
  end

  describe 'sort function' do
    let!(:task1) { create(:task, due_date: '2022/10/04 00:00:00', user: user) }
    let!(:task2) { create(:task, due_date: '2022/10/05 00:00:00', user: user) }
    let!(:task3) { create(:task, due_date: '2022/10/06 00:00:00', user: user) }
    let!(:task4) { create(:task, due_date: '2022/10/07 00:00:00', user: user) }

    before { visit root_path }

    context 'when open list page(sort by created_at order by desc)' do
      it 'order success' do
        expect(find('tr:nth-child(2)')).to have_content I18n.l task4.created_at
        expect(find('tr:nth-child(3)')).to have_content I18n.l task3.created_at
        expect(find('tr:nth-child(4)')).to have_content I18n.l task2.created_at
        expect(find('tr:nth-child(5)')).to have_content I18n.l task1.created_at
      end
    end

    context 'when click link to sort by due_date asc' do
      it 'order success' do
        click_on 'DueDate' # 1回押すと昇順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task1.due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task4.due_date
      end
    end

    context 'when click link to sort by due_date desc' do
      it 'order success' do
        click_on 'DueDate' # 1回押すと昇順
        click_on 'DueDate' # 2回押すと降順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task4.due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task1.due_date
      end
    end
  end
end
