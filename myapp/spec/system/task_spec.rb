require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let(:task_count) { 20 }
  let!(:tasks) { FactoryBot.create_list(:task, task_count) }

  describe 'Check the screen transitions' do
    before { visit root_path }
    it 'check show page' do
      click_link tasks.last.title
      expect(current_path).to eq task_path(tasks.last.id)
    end
    it 'check new page' do
      click_link I18n.t('common.new')
      expect(current_path).to eq new_task_path
    end
  end

  describe 'Check the index page' do
    before { visit root_path }
    it 'deital' do
      expect(page).to have_content("Tasks (#{task_count})")
      expect(page).to have_content(tasks.last.title)
    end

    it 'Check the sort order' do
      created_ats = page.all('.created_at')
      expect(created_ats.count).to be > 0
      created_ats.each.with_index(1) do |row, index|
        expect(row.text).to eq I18n.l(tasks[task_count - index].created_at)
      end
    end
  end

  describe 'Check the show page' do
    before { visit task_path(tasks.last.id) }
    it 'deital' do
      expect(page).to have_content(tasks.last.title)
      expect(page).to have_content(tasks.last.detail)
      expect(page).to have_link I18n.t('common.edit'), href: edit_task_path(tasks.last)
      expect(page).to have_link I18n.t('common.delete'), href: task_path(tasks.last.id)
    end
  end

  describe 'Check the new task' do
    before { visit new_task_path }

    it 'Can create tasks' do
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

    it 'Can not create tasks' do
      title = 'new Title'
      detail = 'new Detail'
      flush = I18n.t('pages.tasks.flash.fail')

      fill_in I18n.t('activerecord.attributes.task.title'), with: title
      fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
      select I18n.t('activerecord.enum.task.priority.low'), from: I18n.t('activerecord.attributes.task.priority')
      select I18n.t('activerecord.enum.task.status.done'), from: I18n.t('activerecord.attributes.task.status')
      fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.yesterday.strftime('%Y-%m-%d')
      click_button I18n.t('common.submit')

      expect(page).to have_current_path(tasks_path)
      expect(page).to have_content(flush)
    end
  end

  describe 'Check the edit task' do
    before { visit edit_task_path(tasks.last.id) }

    it 'Can edit tasks' do
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

    it 'Can not edit tasks' do
      title = 'edit Title'
      detail = 'edit Detail'
      flush = I18n.t('pages.tasks.flash.fail')

      fill_in I18n.t('activerecord.attributes.task.title'), with: title
      fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
      fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.yesterday.strftime('%Y-%m-%d')
      click_button I18n.t('common.submit')

      expect(page).to have_current_path(task_path(tasks.last))
      expect(page).to have_content(flush)
    end
  end

  describe 'Check the delete' do
    before { visit task_path(tasks.last.id) }
    it 'Can delete tasks' do
      click_link I18n.t('common.delete')

      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t('pages.tasks.flash.deleted'))
    end
  end
end
