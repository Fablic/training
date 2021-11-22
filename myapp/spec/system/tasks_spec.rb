require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true do
  let!(:task) { create(:task) }

  describe 'Index' do
    before do
      visit root_path
    end

    it 'タスク一覧画面が表示される' do
      expect(page).to have_content('Tasks#index')
      expect(page).to have_content('タスク名')
      expect(page).to have_content('説明')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')
    end

    it 'タスク作成画面に遷移できる' do
      click_link 'Create task'
      expect(page).to have_content('Tasks#new')
    end

    it 'タスク詳細画面に遷移できる' do
      click_link task.name
      expect(page).to have_content('Tasks#show')
    end

    it 'Destroyを押すとダイアログが出る' do
      page.dismiss_confirm("Are you sure?") do
        click_link 'Destroy', match: :first
      end
      page.accept_confirm do
        click_link 'Destroy', match: :first
      end
      expect(page).to have_content('タスク削除成功！')
    end
  end

  describe 'New' do
    before do
      visit new_task_path
    end

    it 'タスク作成画面が表示される' do
      expect(page).to have_content('Tasks#new')
    end

    it 'タスク作成が出来る' do
      fill_in 'task_name', with: 'input Task'
      fill_in 'task_description', with: 'input Description'
      click_button 'Post'
      expect(page).to have_content('Tasks#show')
      expect(page).to have_content('タスク作成に成功しました！')
      expect(page).to have_content('input Task')
      expect(page).to have_content('input Description')
    end
  end

  describe 'Show' do
    before do
      visit task_path task
    end

    it 'タスク詳細画面が表示される' do
      expect(page).to have_content('Tasks#show')
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
    end
  end

  describe 'Edit' do
    before do
      visit edit_task_path task
    end

    it 'タスク編集画面が表示される' do
      expect(page).to have_content('Tasks#edit')
    end

    it 'タスク更新が出来る' do
      fill_in 'task_name', with: 'update Task'
      fill_in 'task_description', with: 'update Description'
      click_button 'Post'
      expect(page).to have_content('Tasks#show')
      expect(page).to have_content('タスク更新に成功しました！')
      expect(page).to have_content('update Task')
      expect(page).to have_content('update Description')
    end
  end
end
