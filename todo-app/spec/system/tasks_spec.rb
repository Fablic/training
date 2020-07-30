# frozen_string_literal: true

require 'rails_helper'

describe 'Tasks', type: :system do
  before do
    @app_user = FactoryBot.create(:app_user)
    @task = FactoryBot.create(:task, app_user: @app_user)
    @task_label = FactoryBot.create(:task_label, task: @task)
  end

  it 'Display and Create new task' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link 'タスクを作成する'

    fill_in 'タスクの名前', with: 'Test Task'
    page.execute_script "document.getElementById('task_due_date').type = 'text'"
    fill_in '期限', with: Date.tomorrow.strftime('%Y-%m-%d')
    page.execute_script "document.getElementById('task_due_date').type = 'date'"
    fill_in 'タスクラベル（カンマ区切り）', with: 'label1,label2,label3'
    click_button '作成する'

    expect(page).to have_content 'Test Task'
  end

  it 'Edit task' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link_or_button('編集')

    new_name = 'Update name'

    fill_in 'タスクの名前', with: new_name

    click_button '編集する'

    expect(page).to have_content new_name
  end

  it 'Add Task Label' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link_or_button('編集')

    expect(page).to have_content 'ラベル'

    click_link_or_button('+')

    # wait for display input
    sleep 1

    find('.add-label').set('New label')

    find('.add-label').native.send_keys(:return)

    wait_for_ajax

    expect(page).to have_content 'New label'
  end

  it 'Delete Task Label' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link_or_button('編集')

    expect(page).to have_content 'ラベル'

    find('#tsk-label_' + @task_label.id.to_s).hover

    sleep 1

    find('#tsk-label-del-link_' + @task.id.to_s + '_' + @task_label.id.to_s).click

    wait_for_ajax

    expect(page).not_to have_content 'テストラベル'
  end

  it 'Delete task' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link_or_button('削除')

    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'タスク、タスク名を削除しました。'
  end

  private

  def login
    visit login_path
    fill_in 'ユーザ名', with: @app_user.name
    fill_in 'パスワード', with: 'pass'

    click_link_or_button('ログイン')
  end
end
