require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_list) { create_list(:task, 4) }

  describe 'Index Page' do
    before { visit root_path }

    it 'list view' do
      expect(page).to have_title 'Taskun'
      expect(page).to have_content(task_list.last.title)
    end

    it 'move to create page' do
      click_on '作成'
      expect(page).to have_content 'Tasks#new'
    end

    it 'sort by created_at order by desc' do
      expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.last.created_at
      expect(find('tr:nth-child(3)')).to have_content I18n.l task_list[2].created_at
      expect(find('tr:nth-child(4)')).to have_content I18n.l task_list[1].created_at
      expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.first.created_at
    end

    it 'move to edit page' do
      all('table tr')[1].click_on '編集'
      expect(page).to have_content 'Tasks#edit'
    end

    it 'move to detail page' do
      find('tr:nth-child(2)').click_on task_list.last.title
      expect(page).to have_content 'Tasks#detail'
    end
  end

  describe 'Create Page' do
    before { visit new_task_path }

    it 'create task' do
      fill_in 'task[title]',       with: task_list.last.title
      fill_in 'task[description]', with: task_list.last.description
      click_button '送信'
      expect(page).to have_content 'Successfully created'
      expect(page).to have_content 'Tasks#list'
    end

    it 'back to index' do
      click_on class: 'button-back'
      expect(page).to have_content 'Tasks#list'
    end
  end

  describe 'Edit Page' do
    before { visit edit_task_path(task_list.first.id) }

    let(:params) { { title: 'title for edit', description: 'description for edit' } }

    it 'list task detail' do
      expect(page).to have_field '件名', with: task_list.first.title
      expect(page).to have_field '詳細', with: task_list.first.description
    end

    it 'edit and resister task' do
      fill_in 'task[title]',       with: params[:title]
      fill_in 'task[description]', with: params[:description]
      click_button '送信'
      expect(page).to have_content 'Successfully updated'
      expect(page).to have_content 'Tasks#list'
    end
  end

  describe 'Detail Page' do
    before { visit task_path(task_list.first.id) }

    it 'list task details' do
      expect(page).to have_content task_list.first.title
      expect(page).to have_content task_list.first.description
    end

    it 'back to list page' do
      click_on '戻る'
      expect(page).to have_content 'Tasks#list'
    end
  end
end
