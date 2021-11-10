# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do

  # 画面ラベル名
  let(:label_task_name) { I18n.t('tasks.common.task_name') }
  let(:label_description) { I18n.t('tasks.common.description') }
  let(:label_status) { I18n.t('tasks.common.status') }
  let(:label_priority) { I18n.t('tasks.common.priority') }
  let(:label_label) { I18n.t('tasks.common.label') }
  let(:label_start_date) { I18n.t('tasks.common.start_date') }
  let(:label_end_date) { I18n.t('tasks.common.end_date') }
  # 項目設定値
  let(:input_task_name) { 'input Task' }
  let(:input_description) { 'input Description' }
  let(:input_status) { 'todo' }
  let(:input_priority) { 1 }
  let(:input_label) { 'input Label' }
  let(:input_start_date) { Time.zone.yesterday.strftime('%Y-%m-%d') }
  let(:input_end_date) { Time.zone.now.strftime('%Y-%m-%d') }

  let!(:task_list) { create_list(:task, 5) }

  describe 'New task' do
    before { visit new_task_path() }

    it 'show display' do
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(page).to have_title 'Myapp'
      expect(page).to have_content label_task_name
      expect(page).to have_content label_description
      expect(page).to have_content label_status
      expect(page).to have_content label_priority
      expect(page).to have_content label_label
      expect(page).to have_content label_start_date
      expect(page).to have_content label_end_date
    end

    it 'registration' do
      fill_in 'task_task_name', with: input_task_name
      fill_in 'task_description', with: input_description
      select(value = input_status, from: 'task_status')
      fill_in 'task_priority', with: input_priority
      fill_in 'task_label', with: input_label
      fill_in 'task_start_date', with: input_start_date
      fill_in 'task_end_date', with: input_end_date

      click_button I18n.t('helpers.submit.create')

      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_content I18n.t('tasks.flash.complete_task_registration')
    end

    it "go to Task's list" do
      click_on I18n.t('tasks.common.move_task_list')
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Show task' do

    before {
      visit root_path
      # move to Show
      page.all('#click_show')[0].click
    }

    it 'show display' do
      expect(page).to have_content I18n.t('tasks.show.title')
    end

    it "go to Task's list" do
      click_on I18n.t('tasks.common.move_task_list')
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Edit task' do
    before {
      visit root_path
      # move to Edit
      page.all('#click_edit')[0].click
    }

    it 'show display' do
      expect(page).to have_content I18n.t('tasks.edit.title')\
    end

    it "go to Task's list" do
      click_on I18n.t('tasks.common.move_task_list')
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  describe 'Delete task' do
    before {
      visit root_path
    }

    it 'Destroy' do
      page.all('#click_destroy')[0].click
      
      expect(page).to have_content I18n.t('tasks.index.title')
      expect(page).to have_content I18n.t('tasks.flash.complete_task_destroy')
    end
  end

  describe 'Index' do

    before { visit root_path }

    it 'table colums check' do
      within('#task_list') do
        expect(page).to have_content I18n.t('tasks.common.task_name')
      end
    end

    it 'Go to registration page' do
      click_on I18n.t('tasks.index.move_new_task')
      expect(page).to have_content I18n.t('tasks.new.title')
    end

    it 'Go to Show page' do
      #byebug
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
        click_on label_end_date # 1回押す(昇順)
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(2)')).to have_content I18n.l task_list[1].end_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content I18n.l task_list[3].end_date
      end
    end

    context 'when click link to sort by due_date desc' do
      it 'sort success' do
        click_on label_end_date # 1回押す(昇順)
        click_on label_end_date # 2回押す(降順)
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(2)')).to have_content I18n.l task_list[3].end_date
        expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content I18n.l task_list[1].end_date
      end
    end

  end

  describe 'search with title' do
    before { visit root_path }

    let(:task_name) { 'task_name for test' }
    let(:status) { 'done' }
    let(:task_search) { create(:task, task_name: task_name, status: status) }
    
    context 'when search by first' do
      let(:task_name) { 'search_keyword' }

      it 'search success' do
        byebug
        fill_in 'search_task_name', with: 'first'
        click_on I18n.t('helpers.submit.search')

        expect(find('tr:nth-child(2)')).to have_content 'search_keyword'
        expect(find('tr:nth-child(2)')).not_to have_content 'task_name' # factories.fasks.rbにセットされたデータは検索できないこと
      end
    end

  #   context 'when search by last' do
  #     it 'search success' do
  #       fill_in 'q[title_cont]', with: 'last'
  #       click_on '検索'
  #       expect(find('tr:nth-child(2)')).to have_content 'last'
  #       expect(find('tr:nth-child(2)')).not_to have_content 'first'
  #     end
  #   end
  end
end
