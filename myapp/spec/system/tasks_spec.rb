require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
#  before do
#    @user = User.create!(name: 'いとう')
#  end

  it 'create new task' do
    # タスク作成画面を開く
    visit new_task_path

    expect(page).to have_content 'タスク作成'

    fill_in 'task[title]', with: 'お試しタスク'
    fill_in 'task[body]', with: 'ないよー'
    fill_in 'task[deadline]', with: '2022-03-10'
    select 'middle', from: 'task[priority]'
    select '着手', from: 'task[status]'

    expect(page).to have_field 'task[title]', with: 'お試しタスク'
    expect(page).to have_field 'task[body]', with: 'ないよー'
    expect(page).to have_field 'task[deadline]', with: '2022-03-10'
    expect(page).to have_field 'task[priority]', with: 'middle'
    expect(page).to have_field 'task[status]', with: '着手'

    click_button '登録'

    # 保存成功メッセージ
    expect(page).to have_content '保存しました'
    # 保存内容
    expect(page).to have_content 'タスク名:'
    expect(page).to have_content 'お試しタスク'
    expect(page).to have_content '内容:'
    expect(page).to have_content 'ないよー'
    expect(page).to have_content '終了期限:'
    expect(page).to have_content '2022-03-10'
    expect(page).to have_content '優先順位:'
    expect(page).to have_content 'middle'
    expect(page).to have_content 'ステータス:'
    expect(page).to have_content '着手'

  end
end