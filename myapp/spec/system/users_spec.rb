require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = Task.create!(title: 'test task title', description: 'test task description')
  end

  it 'completes yubinbango automatically with JS' do
    # Task編集画面を開く
    visit edit_task_path(@task)

    # Nameに"いとう"が入力されていることを検証する
    expect(page).to have_field 'title', with: 'test task title'

    # 郵便番号を入力
    fill_in 'title', with: 'test task title updated'

    # 更新実行
    click_button 'update'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to have_content 'test task title updated'
  end
end
