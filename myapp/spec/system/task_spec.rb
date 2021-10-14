require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let!(:task) { FactoryBot.create(:task) }

  describe 'Check the screen transitions' do
    before { visit root_path }
    it 'check show page' do
      click_link task.title
      expect(current_path).to eq task_path(task.id)
    end
    it 'check new page' do
      click_link I18n.t('common.new')
      expect(current_path).to eq new_task_path
    end
  end

  describe 'Check the index page' do
    before { visit root_path }
    it 'deital' do
      expect(page).to have_content('Tasks (1)')
      expect(page).to have_content(task.title)
    end
  end

  describe 'Check the show page' do
    before { visit task_path(task.id) }
    it 'deital' do
      expect(page).to have_content(task.title)
      expect(page).to have_content(task.detail)
      expect(page).to have_link I18n.t('common.edit'), href: edit_task_path(task)
      expect(page).to have_link I18n.t('common.delete'), href: task_path(task.id)
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
    before { visit edit_task_path(task) }

    it 'Can edit tasks' do
      title = 'edit Title'
      detail = 'edit Detail'
      flush = I18n.t('pages.tasks.flash.edited')

      fill_in I18n.t('activerecord.attributes.task.title'), with: title
      fill_in I18n.t('activerecord.attributes.task.detail'), with: detail
      fill_in I18n.t('activerecord.attributes.task.due_date'), with: Time.zone.now.tomorrow.strftime('%Y-%m-%d')
      click_button I18n.t('common.submit')

      expect(page).to have_current_path(task_path(task))
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

      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content(flush)
    end
  end

  describe 'Check the delete' do
    before { visit task_path(task.id) }
    it 'Can delete tasks' do
      click_link I18n.t('common.delete')

      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t('pages.tasks.flash.deleted'))
    end
  end
end
