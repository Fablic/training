require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_list) { create_list(:task, 10) }

  describe 'Index Page' do
    before { visit root_path }

    it 'list view' do
      expect(page).to have_title 'Taskun'
      expect(page).to have_content(task_list.last.title)
    end

    it 'move to create page' do
      click_on class: 'task-new'
      expect(page).to have_content 'Tasks#new'
    end

    it 'move to edit page' do
      all('table tr')[1].click_on 'Edit'
      expect(page).to have_content 'Tasks#edit'
    end

    # コンテンツが削除されたことを確認(js:trueにできないためskip)
    # it ' delete' do
    # end

    it 'move to detail page' do
      all('table tr')[1].click_on task_list.first.title
      expect(page).to have_content 'Tasks#detail'
    end
  end

  describe 'Create Page' do
    before { visit new_task_path }

    it 'create task' do
      fill_in 'task[title]',       with: task_list.last.title
      fill_in 'task[description]', with: task_list.last.description
      click_button 'submit'
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
      expect(page).to have_field 'title', with: task_list.first.title
      expect(page).to have_field 'description', with: task_list.first.description
    end
    it 'edit and resister task' do
      fill_in 'task[title]',       with: params[:title]
      fill_in 'task[description]', with: params[:description]
      click_button 'submit'
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
      click_on 'back to task list'
      expect(page).to have_content 'Tasks#list'
    end
  end
end
