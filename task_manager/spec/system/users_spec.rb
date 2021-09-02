# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it '詳細ページの確認' do
    visit user_path(user)

    expect(page).to have_content 'Taro'
    expect(page).to have_content user.email
  end

  context '編集が行われているかの確認' do
    before {
      visit user_path(user)
      click_button 'ユーザーを編集する'
    }

    it '既存のユーザー情報が書いている' do
      expect(page).to have_field 'ユーザー名', with: 'Taro'
    end

    it 'ユーザーを編集できる' do
      fill_in 'ユーザー名', with: 'Hanako'
      click_button '投稿'

      expect(page).to have_content 'ユーザーの更新をしました。'
      expect(page).to have_content 'Hanako'
    end
  end

  context 'ユーザーを新規作成できるかの確認' do
    before { visit new_user_path }

    it '全ての項目を入力して成功する' do
      fill_in 'ユーザー名', with: 'Kuma'
      fill_in 'メールアドレス', with: 'kuma@rakuten.com'
      fill_in 'パスワード', with: 'raspberry'
      fill_in 'パスワードの再確認', with: 'raspberry'
      click_button '投稿'

      expect(page).to have_content 'ユーザーの新規作成をしました。'
      expect(page).to have_content 'Kuma'
      expect(page).to have_content 'kuma@rakuten.com'
    end
  end

  it '削除の確認' do
    visit user_path(user)
    page.accept_confirm do
      find('a', text: 'ユーザーを削除する').click
    end

    # 画面を検証する
    expect(page).to have_content 'ユーザーの削除をしました。'
  end
end
