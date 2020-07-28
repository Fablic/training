# frozen_string_literal: true

require 'rails_helper'

describe 'Tasks', type: :system do
  before do
    @app_user = FactoryBot.create(:app_user)
    @task = FactoryBot.create(:task, app_user: @app_user)
  end

  it 'Display and Create new task' do
    login

    visit tasks_path

    expect(page).to have_content 'タスク名'

    click_link 'タスクを作成する'

    fill_in 'タスクの名前', with: 'Test Task'
    page.execute_script 'document.getElementById("task_due_date").type = "text"'
    fill_in '期限', with: Date.tomorrow.strftime('%Y-%m-%d')
    page.execute_script 'document.getElementById("task_due_date").type = "date"'

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
