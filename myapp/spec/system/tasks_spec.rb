require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true do
  # let!(:task) { create(:task) }
  let!(:task_list) { create_list(:task,5) }

  describe 'タスク一覧画面' do
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

    it '登録してあるタスクが表示される' do
      expect(page).to have_content(task_list[0].name)
      expect(page).to have_content(task_list[1].name)
      expect(page).to have_content(task_list[2].name)
      expect(page).to have_content(task_list[3].name)
      expect(page).to have_content(task_list[4].name)
    end

    it 'タスク作成画面に遷移できる' do
      click_link 'Create task'
      expect(page).to have_content('Tasks#new')
    end

    it '表示されてるタスク名を選択してタスク詳細画面に遷移できる' do
      click_link task_list[0].name
      expect(page).to have_content('Tasks#show')
    end

    it '表示されてるタスクのEditを選択してタスク編集画面に遷移できる' do
      all('tbody tr')[0].click_link 'Edit'
      expect(page).to have_content('Tasks#edit')
    end

    it '表示されてるタスクのDestroyを押すと削除確認ダイアログが出て削除ができる' do
      page.dismiss_confirm("Are you sure?") do
        click_link 'Destroy', match: :first
      end
      page.accept_confirm do
        click_link 'Destroy', match: :first
      end
      expect(page).to have_content('タスク削除成功！')
    end
  end

  describe 'タスク作成画面' do
    before do
      visit new_task_path
    end

    it 'タスク作成画面が表示される' do
      expect(page).to have_content('Tasks#new')
    end

    it '新しくタスクが作成出来る' do
      fill_in 'task_name', with: 'input Task'
      fill_in 'task_description', with: 'input Description'
      click_button 'Post'
      expect(page).to have_content('Tasks#show')
      expect(page).to have_content('タスク作成に成功しました！')
      expect(page).to have_content('input Task')
      expect(page).to have_content('input Description')
    end
  end

  describe 'タスク詳細画面' do
    before do
      visit task_path task_list[0]
    end

    it 'タスク詳細画面が表示される' do
      expect(page).to have_content('Tasks#show')
    end

    it '選択したタスクの詳細情報が表示される' do
      expect(page).to have_content(task_list[0].name)
      expect(page).to have_content(task_list[0].description)
    end
  end

  describe 'タスク編集画面' do
    before do
      visit edit_task_path task_list[0]
    end

    it 'タスク編集画面が表示される' do
      expect(page).to have_content('Tasks#edit')
    end

    it 'タスクを選択して情報更新が出来る' do
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
