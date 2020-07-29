# frozen_string_literal: true

require 'rails_helper'

describe 'AdminUsers', type: :system do
  before do
    @app_user = FactoryBot.create(:admin_user)
    @task = FactoryBot.create(:task, app_user: @app_user)

    @standard_user = FactoryBot.create(:app_user)
    @task = FactoryBot.create(:task, app_user: @standard_user, name: 'スタンダードユーザのタスク')
  end

  it 'Display and Create new User' do
    login

    expect(page).to have_content 'タスク一覧'

    click_link '管理者機能'

    click_link 'ユーザー管理'

    click_link 'ユーザを作成する'

    fill_in 'ユーザー名', with: 'TestUser1'

    fill_in 'パスワード', with: 'changeme'

    fill_in 'パスワード (確認)', with: 'changeme'

    click_button '作成する'

    expect(page).to have_content 'TestUser1'
  end

  it 'Suspend / Open user' do
    login

    expect(page).to have_content 'タスク一覧'

    click_link '管理者機能'

    click_link 'ユーザー管理'

    accept_alert do
      click_button '利用を停止する'
    end

    wait_for_ajax

    expect(page).to have_content 'Yes'

    accept_alert do
      click_button '利用を開始する'
    end

    wait_for_ajax

    expect(page).not_to have_content 'Yes'
  end

  it 'Destroy user' do
    login

    expect(page).to have_content 'タスク一覧'

    click_link '管理者機能'

    click_link 'ユーザー管理'

    expect(AppUser.all.size).to eq 2

    accept_alert do
      click_button '削除する'
    end

    accept_alert

    wait_for_ajax

    expect(AppUser.all.size).to eq 1
  end

  def login
    visit login_path
    fill_in 'ユーザ名', with: @app_user.name
    fill_in 'パスワード', with: 'pass'

    click_link_or_button('ログイン')
  end
end
