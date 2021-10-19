require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let(:task_count) { 20 }
  let!(:tasks) { FactoryBot.create_list(:task, task_count) }

  describe '#index' do
    before { visit root_path }
    context 'Go to the show page.' do
      it 'Successful transition' do
        click_link tasks.last.title
        expect(current_path).to eq task_path(tasks.last.id)
      end
    end

    context 'Go to the new page.' do
      it 'Successful transition' do
        click_link I18n.t('common.new')
        expect(current_path).to eq new_task_path
      end
    end

    context 'Is the task list represented?' do
      it 'Displayed.' do
        expect(page).to have_content("Tasks (#{task_count})")
        expect(page).to have_content(tasks.last.title)
      end
    end

    context 'Is it sorted by created_at?' do
      it 'Displayed.' do
        visit root_path(direction: 'desc', sort: 'created_at')
        created_ats = page.all('.sort_created_at')
        expect(created_ats.count).to be > 0
        created_ats.each.with_index(1) do |row, index|
          expect(row.text).to eq I18n.l(tasks[task_count - index].created_at)
        end
      end
    end

    it 'Check the sort order due_date' do
      visit root_path(direction: 'asc', sort: 'due_date')
      columns = page.all('.sort_due_date')
      expect(columns.count).to be > 0
      columns.each.with_index(1) do |row, index|
        expect(row.text).to eq I18n.l(tasks[task_count - index].due_date)
      end
    end
  end

  describe '#show' do
    before { visit task_path(tasks.last.id) }
    context 'Is the task list represented?' do
      it 'Displayed.' do
        expect(page).to have_content(tasks.last.title)
        expect(page).to have_content(tasks.last.detail)
        expect(page).to have_link I18n.t('common.edit'), href: edit_task_path(tasks.last)
        expect(page).to have_link I18n.t('common.delete'), href: task_path(tasks.last.id)
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }

    context 'If the task is registered successfully' do
      it 'Screen transition.' do
        title = 'new Title'
        detail = 'new Detail'
        flush = I18n.t('pages.tasks.flash.added')

        fill_in I18n.t('activerecord.attributes.task.title'), with: title
        fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
        select I18n.t('activerecord.enum.task.priority.low'), from: I18n.t('activerecord.attributes.task.priority')
        select I18n.t('activerecord.enum.task.status.done'), from: I18n.t('activerecord.attributes.task.status')
        fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.tomorrow.strftime('%Y-%m-%d')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(flush)

        click_link title
        expect(page).to have_content(detail)
        expect(page).not_to have_content(flush)
      end
    end

    context 'If the registration of a task fails' do
      it 'Display an error without transitioning.' do
        title = 'new Title'
        detail = 'new Detail'

        fill_in I18n.t('activerecord.attributes.task.title'), with: title
        fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
        select I18n.t('activerecord.enum.task.priority.low'), from: I18n.t('activerecord.attributes.task.priority')
        select I18n.t('activerecord.enum.task.status.done'), from: I18n.t('activerecord.attributes.task.status')
        fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.yesterday.strftime('%Y-%m-%d')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content(I18n.t('form.error', smtg: 1))
        expect(page).to have_content(I18n.t('activerecord.errors.models.task.attributes.due_date.error'))
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path(tasks.last.id) }

    context 'If the task is edit successfully' do
      it 'Screen transition.' do
        title = 'edit Title'
        detail = 'edit Detail'
        flush = I18n.t('pages.tasks.flash.edited')

        fill_in I18n.t('activerecord.attributes.task.title'), with: title
        fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
        fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.now.tomorrow.strftime('%Y-%m-%d')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(task_path(tasks.last))
        expect(page).to have_content(flush)
        expect(page).to have_content(title)
        expect(page).to have_content(detail)
      end
    end

    context 'If the edit of a task fails.' do
      it 'Display an error without transitioning.' do
        title = 'edit Title'
        detail = 'edit Detail'

        fill_in I18n.t('activerecord.attributes.task.title'), with: title
        fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
        fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.yesterday.strftime('%Y-%m-%d')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(task_path(tasks.last))
        expect(page).to have_content(I18n.t('form.error', smtg: 1))
        expect(page).to have_content(I18n.t('activerecord.errors.models.task.attributes.due_date.error'))
      end
    end
  end

  describe '#delete' do
    before { visit task_path(tasks.last.id) }
    context 'If the task is delete successfully' do
      it 'Screen transition.' do
        click_link I18n.t('common.delete')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.tasks.flash.deleted'))
      end
    end
  end
end
