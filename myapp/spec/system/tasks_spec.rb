# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    //
  end

  it 'input and submit form' do
    # User編集画面を開く
    visit new_task_path()

    # Nameに"いとう"が入力されていることを検証する
    expect(page).to have_field '名前', with: ''

    # 郵便番号を入力
    fill_in '郵便番号', with: '158-0083'
    # 住所が自動入力されたことを検証する
    expect(page).to have_field 'title', with: ''

    # 更新実行
    click_button 'Update User'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to have_content 'User was successfully updated.'
    expect(page).to have_content 'いとう'
    expect(page).to have_content '158-0083'
    expect(page).to have_content '東京都世田谷区奥沢'
  end
end
