require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'Tasklist' do
    shared_examples 'Checking component' do
      it 'displays common components' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_link(I18n.t('views.common.add'))
        expect(page).to have_button(I18n.t('views.common.login'))
        expect(page).to have_button(I18n.t('views.common.search'))
        expect(page).to have_link(I18n.t('views.common.reset'))
        expect(page).to have_field(I18n.t('activerecord.attributes.task.title'))
        expect(page).to have_select('status', options: [
                                      I18n.t('views.common.all_status'),
                                      I18n.t('activerecord.attributes.task.status.not_started'),
                                      I18n.t('activerecord.attributes.task.status.in_progress'),
                                      I18n.t('activerecord.attributes.task.status.completed')
                                    ])
      end
    end

    context 'When no tasks exist' do
      before do
        visit tasks_path
      end

      it_behaves_like 'Checking component'
      it 'displays "no tasks" message' do
        expect(page).to have_content(I18n.t('views.tasks.index.no_tasks'))
      end
    end

    context 'When any tasks exist' do
      before do
        @task1 = Task.create!(title: 'ryu title1', details: 'ryu details1', created_at: 1.day.ago)
        @task2 = Task.create!(title: 'ryu title2', details: 'ryu details2', created_at: 2.days.ago)
        @task3 = Task.create!(title: 'ryu title3', details: 'ryu details3', created_at: Time.now)
        visit tasks_path
      end

      it_behaves_like 'Checking component'
      it 'displays Items in the correct order' do
        expect(page).to have_selector('tr>th', text: I18n.t('helpers.label.task.title'))
        expect(find('tbody tr:nth-child(1)')).to have_link(@task3.title)
        expect(find('tbody tr:nth-child(2)')).to have_link(@task1.title)
        expect(find('tbody tr:nth-child(3)')).to have_link(@task2.title)
        expect(page).to have_selector('tbody tr:nth-child(1)', text: @task3.created_at.strftime('%Y/%m/%d %H:%M:%S'))
        expect(page).to have_selector('tbody tr:nth-child(2)', text: @task1.created_at.strftime('%Y/%m/%d %H:%M:%S'))
        expect(page).to have_selector('tbody tr:nth-child(3)', text: @task2.created_at.strftime('%Y/%m/%d %H:%M:%S'))
      end
    end
  end

  describe 'New task' do
    context 'Initial display' do
      before do
        visit tasks_path
        click_link I18n.t('views.common.add')
      end

      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.new.title'))
        expect(page).to have_field(I18n.t('helpers.label.task.title'), readonly: false)
        expect(page).to have_field(I18n.t('helpers.label.task.details'), readonly: false)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_button(I18n.t('helpers.submit.create'))
      end
    end

    context 'When cancelling' do
      before do
        visit new_task_path
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the Task page' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
      end
    end

    context 'When the task is valid' do
      let(:valid_params) { { title: '全' * 100, details: '角' * 1000 } }

      before do
        visit new_task_path
        fill_in I18n.t('helpers.label.task.title'), with: valid_params[:title]
        fill_in I18n.t('helpers.label.task.details'), with: valid_params[:details]
        click_button I18n.t('helpers.submit.create')
      end

      it 'shows a success message on the Tasks page' do
        expect(Task.count).to eq(1)
        expect(Task.last.title).to eq(valid_params[:title])
        expect(Task.last.details).to eq(valid_params[:details])
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.create')))
      end
    end

    context 'When the task is invalid' do
      before do
        visit new_task_path
        fill_in I18n.t('helpers.label.task.title'), with: '  '
        fill_in I18n.t('helpers.label.task.details'), with: 'N' * 1001
        click_button I18n.t('helpers.submit.create')
      end
      it 'shows a error message on the New page' do
        expect(Task.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.new.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.create')))
        expect(page).to have_content(I18n.t('activerecord.attributes.task.title') + I18n.t('activerecord.errors.messages.blank'))
        expect(page).to have_content(I18n.t('activerecord.attributes.task.details') + I18n.t('activerecord.errors.messages.too_long', count: 1000))
      end
    end
  end

  describe 'Show task' do
    let!(:task) { Task.create!(title: 'ryu title3', details: 'ryu details3') }

    context 'Initial display' do
      before do
        visit tasks_path
        click_link task.title
      end
      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.show.title'))
        expect(page).to have_field(I18n.t('helpers.label.task.title'), with: task.title, readonly: true)
        expect(page).to have_field(I18n.t('helpers.label.task.details'), with: task.details, readonly: true)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_link(I18n.t('views.common.edit'))
      end
    end

    context 'When cancelling' do
      before do
        visit task_path(task)
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the Task page' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
      end
    end

    context 'When deleting the Task' do
      before do
        visit task_path(task)
        click_button I18n.t('views.common.delete')
      end

      it 'shows a success message on the Tasks page' do
        expect(Task.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.destroy')))
      end
    end
  end

  describe 'Edit task' do
    let!(:task) { Task.create!(title: 'ryu title3', details: 'ryu details3') }

    context 'Initial display' do
      before do
        visit task_path(task)
        click_link I18n.t('views.common.edit')
      end
      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.edit.title'))
        expect(page).to have_field(I18n.t('helpers.label.task.title'), with: task.title, readonly: false)
        expect(page).to have_field(I18n.t('helpers.label.task.details'), with: task.details, readonly: false)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_button(I18n.t('helpers.submit.update'))
      end
    end

    context 'When cancelling' do
      before do
        visit edit_task_path(task)
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the Task page' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
      end
    end

    context 'When deleting the Task' do
      before do
        visit edit_task_path(task)
        click_button I18n.t('views.common.delete')
      end

      it 'shows a success message on the Tasks page' do
        expect(Task.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.destroy')))
      end
    end

    context 'When updating the Task with valid data' do
      let(:valid_params) { { title: '全' * 100, details: '角' * 1000 } }
      before do
        visit edit_task_path(task)
        fill_in I18n.t('helpers.label.task.title'), with: valid_params[:title]
        fill_in I18n.t('helpers.label.task.details'), with: valid_params[:details]
        click_button I18n.t('helpers.submit.update')
      end

      it 'shows a success message on the Tasks page' do
        expect(Task.count).to eq(1)
        expect(Task.last.title).to eq(valid_params[:title])
        expect(Task.last.details).to eq(valid_params[:details])
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.update')))
      end
    end

    context 'When updating the Task with invalid data' do
      before do
        visit edit_task_path(task)
        fill_in I18n.t('helpers.label.task.title'), with: 'A' * 101
        fill_in I18n.t('helpers.label.task.details'), with: 'NG Case'
        click_button I18n.t('helpers.submit.update')
      end

      it 'shows a error message on the Edit page' do
        expect(Task.count).to eq(1)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.edit.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.update')))
        expect(page).to have_content(I18n.t('activerecord.attributes.task.title') + I18n.t('activerecord.errors.messages.too_long', count: 100))
      end
    end
  end

  describe 'Test for Search' do
    let!(:task1) { Task.create!(title: 'Task@1', status: :not_started) }
    let!(:task2) { Task.create!(title: 'Task%2', status: :in_progress) }
    let!(:task3) { Task.create!(title: 'Task-3', status: :completed) }

    context 'Case Search button' do
      it 'has the hitted tasks witg no condition ' do
        visit tasks_path
        click_button I18n.t('views.common.search')

        expect(page).to have_content(task2.title)
        expect(page).to have_content(task1.title)
        expect(page).to have_content(task3.title)
      end

      it 'has the hitted tasks only with Status condition ' do
        visit tasks_path
        select I18n.t('activerecord.attributes.task.status.in_progress'), from: 'status'
        click_button I18n.t('views.common.search')

        expect(page).to have_content(task2.title)
        expect(page).not_to have_content(task1.title)
        expect(page).not_to have_content(task3.title)
      end

      it 'has the hitted tasks only with Title condition' do
        visit tasks_path
        fill_in 'title', with: '-3'
        click_button I18n.t('views.common.search')

        expect(page).to have_content(task3.title)
        expect(page).not_to have_content(task1.title)
        expect(page).not_to have_content(task2.title)
      end

      it 'has the hitted tasks with both' do
        visit tasks_path
        fill_in 'title', with: 'Task'
        select I18n.t('activerecord.attributes.task.status.not_started'), from: 'status'
        click_button I18n.t('views.common.search')

        expect(page).to have_content(task1.title)
        expect(page).not_to have_content(task2.title)
        expect(page).not_to have_content(task3.title)
      end

      it 'has the hitted tasks with both' do
        visit tasks_path
        fill_in 'title', with: 'Task@'
        select I18n.t('activerecord.attributes.task.status.not_started'), from: 'status'
        click_button I18n.t('views.common.search')

        expect(page).to have_content(task1.title)
        expect(page).not_to have_content(task2.title)
        expect(page).not_to have_content(task3.title)
      end

      it 'has no hitted' do
        visit tasks_path
        fill_in 'title', with: '-4'
        select I18n.t('activerecord.attributes.task.status.completed'), from: 'status'
        click_button I18n.t('views.common.search')

        expect(page).to have_content(I18n.t('views.tasks.index.no_tasks'))
      end
    end

    context 'Case Reset button' do
      it 'shows all tasks list' do
        visit tasks_path
        fill_in 'title', with: 'k%'
        select I18n.t('activerecord.attributes.task.status.in_progress'), from: 'status'
        click_link I18n.t('views.common.reset')

        expect(page).to have_content(task1.title)
        expect(page).to have_content(task2.title)
        expect(page).to have_content(task3.title)
      end
    end
  end

  describe 'Pagination / 6 tasks per page' do
    context 'If # of Task is less than # per page' do
      before do
        6.times do |i|
          Task.create!(title: %(ryu title#{i}), details: %(ryu details#{i}), created_at: Time.now)
        end
        visit tasks_path
      end
      it 'has no page labels' do
        expect(page).not_to have_selector("nav[class='pagination']")
        6.times do |i|
          expect(page).to have_content(%(ryu title#{i}))
        end
      end
    end

    context 'If # of Task is over # per page' do
      before do
        8.times do |i|
          Task.create!(title: %(ryu title#{i}), details: %(ryu details#{i}), created_at: Time.now)
        end
        visit tasks_path
      end

      it 'shows the first page' do
        (2..6).each do |i|
          expect(page).to have_content(%(ryu title#{i}))
        end
        expect(find("nav[class='pagination']")).to have_content('1')
        expect(find("nav[class='pagination']")).to have_link('2')
        expect(find("nav[class='pagination']")).to have_link('›')
        expect(find("nav[class='pagination']")).to have_link('»')
      end

      it 'shows the second page' do
        click_link '2'
        expect(page).to have_content('ryu title1')
        expect(page).to have_content('ryu title0')
        expect(find("nav[class='pagination']")).to have_link('«')
        expect(find("nav[class='pagination']")).to have_link('‹')
        expect(find("nav[class='pagination']")).to have_link('1')
        expect(find("nav[class='pagination']")).to have_content('2')
      end
    end
  end
end
