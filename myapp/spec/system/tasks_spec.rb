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

  # describe 'New task' do
  #   before { visit new_task_path() }

  #   it 'show display' do
  #     expect(page).to have_content I18n.t('tasks.new.title')
  #     expect(page).to have_title 'Myapp'
  #     expect(page).to have_content label_task_name
  #     expect(page).to have_content label_description
  #     expect(page).to have_content label_status
  #     expect(page).to have_content label_priority
  #     expect(page).to have_content label_label
  #     expect(page).to have_content label_start_date
  #     expect(page).to have_content label_end_date
  #   end

  #   it 'registration' do
  #     fill_in 'task_task_name', with: input_task_name
  #     fill_in 'task_description', with: input_description
  #     fill_in 'task_status', with: input_status
  #     fill_in 'task_priority', with: input_priority
  #     fill_in 'task_label', with: input_label
  #     fill_in 'task_start_date', with: input_start_date
  #     fill_in 'task_end_date', with: input_end_date

  #     click_button '登録する'

  #     expect(page).to have_current_path root_path, ignore_query: true
  #     expect(page).to have_content I18n.t('tasks.flash.complete_task_registration')
  #   end

  #   it "go to Task's list" do
  #     click_on I18n.t('tasks.common.move_task_list')
  #     expect(page).to have_current_path root_path, ignore_query: true
  #   end
  # end

  # describe 'Show task' do
  #   before {
  #     visit root_path
  #     # move to Show
  #     page.all('#click_show')[0].click
  #   }

  #   it 'show display' do
  #     expect(page).to have_content I18n.t('tasks.show.title')
  #   end

  #   it "go to Task's list" do
  #     click_on I18n.t('tasks.common.move_task_list')
  #     expect(page).to have_current_path root_path, ignore_query: true
  #   end
  # end

  # describe 'Edit task' do
  #   before {
  #     visit root_path
  #     # move to Edit
  #     page.all('#click_edit')[0].click
  #   }

  #   it 'show display' do
  #     expect(page).to have_content I18n.t('tasks.edit.title')\
  #   end

  #   it "go to Task's list" do
  #     click_on I18n.t('tasks.common.move_task_list')
  #     expect(page).to have_current_path root_path, ignore_query: true
  #   end
  # end

  # describe 'Delete task' do
  #   before {
  #     visit root_path
  #   }

  #   it 'Destroy' do
  #     page.accept_confirm do
  #       page.all('#click_destroy')[0].click
  #     end

  #     expect(page).to have_content I18n.t('tasks.index.title')
  #     expect(page).to have_content I18n.t('tasks.flash.complete_task_destroy')
  #   end
  # end

  describe 'Index' do
    let!(:task_list) { create_list(:task, 10) }

    before { visit root_path }

    # it 'table colums check' do
    #   within('#task_list') do
    #     expect(page).to have_content I18n.t('tasks.common.task_name')
    #   end
    # end

    # it 'Go to registration page' do
    #   click_on I18n.t('tasks.index.move_new_task')
    #   expect(page).to have_content I18n.t('tasks.new.title')
    # end

    it 'Go to Show page' do
      byebug
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
      page.dismiss_confirm do
        page.all('#click_destroy')[0].click
      end
      expect(page).to have_content I18n.t('tasks.index.title')
    end
  
    it 'Check sort' do
      created_list = page.all('.created_at')
      expect(created_list.count).to be > 0
      created_list.each.with_index(1) do |row, index|
        expect(row.text).to eq I18n.l(tasks[task_count - index].created_at)
      end
    end
  end

  end

end
