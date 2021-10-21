require 'rails_helper'

RSpec.describe TasksController, type: :system do
  let(:task_count) { 20 }
  let!(:tasks) { FactoryBot.create_list(:task, task_count) }

  shared_examples 'When the task list is sorted' do
    it 'Displayed in a sorted' do
      visit root_path(direction: direction, sort: sort)
      columns = page.all(".sort_#{sort}")
      expect(columns.count).to be > 0
      expect(columns.map(&:text)).to match(tasks.reverse.map { |t| I18n.l(t.send(sort)) })
    end
  end

  shared_examples 'When searching for status' do
    it 'Only the specified status will be displayed.' do
      visit root_path(direction: 'desc', sort: sort)
      select I18n.t("activerecord.enum.task.status.#{status}"), from: 'status'
      click_button I18n.t('pages.tasks.search.title')
      page.all('.sort_status').map { |c| expect(c.text).to eq I18n.t("activerecord.enum.task.status.#{status}") }

      columns = page.all(".sort_#{sort}")
      expect(columns.count).to eq count
      expect(columns.map(&:text)).to match(tasks.reverse.map { |t| I18n.l(t.send(sort)) }) if count > 0
    end
  end

  shared_examples 'When searching for title with' do
    it 'Only tasks that contain XXX will be displayed.' do
      visit root_path(direction: 'desc', sort: 'due_date')

      fill_in 'title', with: title
      click_button I18n.t('pages.tasks.search.title')

      columns = page.all('.sort_due_date')
      tasks_include_title = tasks.find_all { |task| task.title.include?(title) }
      expect(columns.map(&:text)).to match(tasks_include_title.map { |t| I18n.l(t.due_date) }.reverse)
    end
  end

  describe '#index' do
    before { visit root_path }
    context 'When the show page is accessed.' do
      it 'Successful transition' do
        click_link tasks.last.title
        expect(current_path).to eq task_path(tasks.last.id)
      end
    end

    context 'When the new page is accessed.' do
      it 'Successful transition' do
        click_link I18n.t('common.new')
        expect(current_path).to eq new_task_path
      end
    end

    context 'When the index page is accessed.' do
      it 'The title appears.' do
        expect(page).to have_content('Tasks')
        expect(page).to have_content(tasks.last.title)
      end
    end

    context 'When sorting by created_at in descending order' do
      let(:sort) { 'created_at' }
      let(:direction) { 'desc' }
      it_behaves_like 'When the task list is sorted'
    end

    context 'When sorting by due_date in order' do
      let(:sort) { 'due_date' }
      let(:direction) { 'asc' }
      it_behaves_like 'When the task list is sorted'
    end

    context 'When searching for status with waiting.' do
      let(:sort) { 'due_date' }
      let(:status) { 'waiting' }
      let(:count) { task_count }
      it_behaves_like 'When searching for status'
    end

    context 'When searching for status with done.' do
      let(:sort) { 'due_date' }
      let(:status) { 'done' }
      let(:count) { 0 }
      it_behaves_like 'When searching for status'
    end

    context 'When searching for title with "2"' do
      let(:title) { '2' }
      it_behaves_like 'When searching for title with'
    end

    context 'When the title is searched for a non-existent character.' do
      let(:title) { 'ZZZZ' }
      it_behaves_like 'When searching for title with'
    end

    context 'When you search for an empty title.' do
      let(:title) { '' }
      it_behaves_like 'When searching for title with'
    end
  end

  describe '#show' do
    before { visit task_path(tasks.last.id) }
    context 'When the show page is accessed.' do
      it 'Task details will be displayed.' do
        expect(page).to have_content(tasks.last.title)
        expect(page).to have_content(tasks.last.detail)
        expect(page).to have_link I18n.t('common.edit'), href: edit_task_path(tasks.last)
        expect(page).to have_link I18n.t('common.delete'), href: task_path(tasks.last.id)
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    let(:title) { 'new Title' }
    let(:detail) { 'new Detail' }

    context 'When a task is registered' do
      it 'Tasks can be registered, and tasks will be displayed.' do
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

    context 'When registration of a task fails' do
      it 'Display an error without transitioning.' do
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
    let(:title) { 'edit Title' }
    let(:detail) { 'edit Detail' }

    context 'When a task is edited' do
      it 'Tasks can be registered, and tasks will be displayed.' do
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

    context 'When edit of a task fails' do
      it 'Display an error without transitioning.' do
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
    context 'When a task is deleted' do
      it 'The task is deleted and the screen transitions.' do
        click_link I18n.t('common.delete')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.tasks.flash.deleted'))
      end
    end
  end
end
