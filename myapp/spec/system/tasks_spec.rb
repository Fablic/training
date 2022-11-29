require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = Task.create!(title: 'Spec', description: 'test')
  end

  it 'Task list page works correctly' do
    # 一覧画面を開く
    visit tasks_path

    # 正しい情報が表示されていること
    expect(page).to have_content 'Tasks'
    expect(page).to have_content 'Spec'
    expect(page).to have_content 'test'
  end

  it 'New task page works correctly' do
    # 新規画面を開く
    visit new_task_path

    # 新規画面が開いてること（titleが空白になってる）
    expect(page).to have_content 'New Task'
    expect(find_field("task_title").text).to be_blank
    expect(page).to have_field 'task_description', with: ""

    # titleとdescriptionを入力
    fill_in 'task_title', with: 'Spec test new task'
    fill_in 'task_description', with: 'Spec test new task description'

    # 登録
    click_button 'Create Task'

    # 正しく登録されていること
    expect(page).to have_content 'Task Detail'
    expect(page).to have_content 'Spec test new task'
    expect(page).to have_content 'Spec test new task description'
  end

  it 'Task detail page works correctly' do
    # 詳細画面を開く
    visit task_path(@task)

    # 正しい情報が表示されていること
    expect(page).to have_content 'Task Detail'
    expect(page).to have_content 'Spec'
    expect(page).to have_content 'test'
  end

  it 'Edit task page works correctly' do
    # タスク編集画面を開く
    visit edit_task_path(@task)

    # titleとdescriptionが正しく表示されること
    expect(page).to have_content 'Edit Task'
    expect(page).to have_field 'task_title', with: 'Spec'
    expect(page).to have_field 'task_description', with: 'test'

    # titleとdescriptionを入力する
    fill_in 'task_title', with: 'Spec first task'
    fill_in 'task_description', with: 'Spec first task description'

    # 更新実行
    click_button 'Update Task'

    # 正しく更新されていること
    expect(page).to have_content 'Task Detail'
    expect(page).to have_content 'Spec first task'
    expect(page).to have_content 'Spec first task description'
  end

  it "Delete works correctly", js: true do
    visit task_path(@task)
    click_link 'Destroy'
    expect do
      expect(page.accept_confirm).to eq "Are you sure?"
    end.to change(Task, :count).by(-1)
    is_expected.not_to have_content @task.title
  end
end
