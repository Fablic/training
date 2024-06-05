require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'Tasklist' do
    shared_examples 'Checking component' do
      it 'displays common components' do
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_link(I18n.t('views.common.add'))
        expect(page).to have_button(I18n.t('views.common.login'))
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
        expect(page).to have_field(I18n.t('views.common.search'))
        expect(page).to have_selector('tr>th', text: I18n.t('activerecord.attributes.task.title'))
        expect(page).to have_link(@task3.title)
        expect(page).to have_link(@task1.title)
        expect(page).to have_link(@task2.title)
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
      before do
        visit new_task_path
        fill_in I18n.t('helpers.label.task.title'), with: 'New ryu title1'
        fill_in I18n.t('helpers.label.task.details'), with: 'New ryu Details1'
        click_button I18n.t('helpers.submit.create')
      end

      it 'shows a success message on the Tasks page' do
        expect(Task.count).to eq(1)
        expect(Task.last.title).to eq('New ryu title1')
        expect(Task.last.details).to eq('New ryu Details1')
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.create')))
      end
    end

    context 'When the task is invalid' do
      before do
        visit new_task_path
        fill_in I18n.t('helpers.label.task.title'), with: '  '
        fill_in I18n.t('helpers.label.task.details'), with: 'New ryu Details1'
        click_button I18n.t('helpers.submit.create')
      end
      it 'shows a error message on the New page' do
        expect(Task.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.new.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.create')))
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
      let!(:valid_params) { { title: 'Ok Ok Ok Title', details: 'Ok Ok Ok Details' } }
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
        fill_in I18n.t('helpers.label.task.title'), with: ''
        fill_in I18n.t('helpers.label.task.details'), with: 'NG Case'
        click_button I18n.t('helpers.submit.update')
      end

      it 'shows a error message on the Edit page' do
        expect(Task.count).to eq(1)
        expect(page).to have_selector('h1', text: I18n.t('views.tasks.edit.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.update')))
      end
    end
  end
end
