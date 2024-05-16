require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = Task.create!(title: 'test task title', description: 'test task description')
  end

  it 'create task' do
    # Task編集画面を開く
    visit new_task_path

    # titleを入力
    fill_in 'task_title', with: 'task title'

    # fill in description
    fill_in 'task_description', with: 'task description'

    # 更新実行
    click_button 'Create Task'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to have_content 'Task created.'
    expect(page).to have_content 'task title'
    expect(page).to have_content 'task description'
  end

  it 'read task' do
    # Task編集画面を開く
    visit task_path(@task)

    # titleに"test task title"が入力されていることを検証する
    expect(page).to have_content 'task title'
    expect(page).to have_content 'task description'
  end

  it 'update task' do
    # Task編集画面を開く
    visit edit_task_path(@task)

    # Check if the title and the description are correct
    expect(page).to have_field 'task_title', with: 'test task title'
    expect(page).to have_field 'task_description', with: 'test task description'

    # fill in title and description
    fill_in 'task_title', with: 'test task title changed'
    fill_in 'task_description', with: 'test task description changed'

    # 更新実行
    click_button 'Update Task'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to have_content 'test task title changed'
    expect(page).to have_content 'test task description changed'
  end

  it 'delete task' do
    # Task編集画面を開く
    visit tasks_path()

    # expect(button['data-confirm']).to eq 'Are you sure?'

    # Nameに"いとう"が入力されていることを検証する
    all('tr')[1].click_button 'delete'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to_not have_content 'test task title'
  end
end
