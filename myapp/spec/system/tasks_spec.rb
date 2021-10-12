require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_list) { create_list(:task, 4) }

  describe 'Index Page' do
    before { visit root_path }
    context 'normal action confirmation' do
      it 'display list view, success' do
        expect(page).to have_title 'Taskun'
        expect(page).to have_content(task_list.last.title)
      end
  
      it 'move to create page, success' do
        click_on '作成'
        expect(page).to have_content 'Tasks#new'
      end
  
      it 'sort by created_at order by desc, success' do
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.last.created_at
        expect(find('tr:nth-child(3)')).to have_content I18n.l task_list[2].created_at
        expect(find('tr:nth-child(4)')).to have_content I18n.l task_list[1].created_at
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.first.created_at
      end

      it 'sort by due_date order by ace, success' do
        click_on '期日で並び替え' # 1回押すと昇順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.first.due_date
        expect(find('tr:nth-child(3)')).to have_content I18n.l task_list[1].due_date
        expect(find('tr:nth-child(4)')).to have_content I18n.l task_list[2].due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.last.due_date
      end

      it 'sort by due_date order by desc, success' do
        click_on '期日で並び替え' # 1回押すと昇順
        click_on '期日で並び替え' # 2回押すと降順
        expect(find('tr:nth-child(2)')).to have_content I18n.l task_list.last.due_date
        expect(find('tr:nth-child(3)')).to have_content I18n.l task_list[2].due_date
        expect(find('tr:nth-child(4)')).to have_content I18n.l task_list[1].due_date
        expect(find('tr:nth-child(5)')).to have_content I18n.l task_list.first.due_date
      end

      it 'move to edit page, success' do
        all('table tr')[1].click_on '編集'
        expect(page).to have_content 'Tasks#edit'
      end
  
      it 'move to detail page, success' do
        find('tr:nth-child(2)').click_on task_list.last.title
        expect(page).to have_content 'Tasks#detail'
      end
    end
  end

  describe 'Create Page' do
    before { visit new_task_path }

    context 'normal action confirmation' do
      it 'create task, success' do
        fill_in 'task[title]',       with: 'new task'
        fill_in 'task[description]', with: 'new description'
        fill_in 'task[due_date]',    with: Faker::Time.forward(days: 23, period: :morning)
        click_button '送信'
        expect(page).to have_content 'Successfully created'
        expect(page).to have_content 'Tasks#list'
      end
  
      it 'back to index page, success' do
        click_on '戻る'
        expect(page).to have_content 'Tasks#list'
      end
    end
  end

  describe 'Edit Page' do
    before { visit edit_task_path(task_list.first.id) }
    context 'normal action confirmation' do
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
  end

  describe 'Detail Page' do
    before { visit task_path(task_list.first.id) }
    context 'normal action confirmation' do
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
end
