# frozen_string_literal: true

require 'rails_helper'
describe 'ログイン機能', type: :system do
  let(:user) { create(:user, name: 'YoshioRakuten', password: 'rakuten') }

  before do
    create(:task, name: '最初のタスク', status: 'not_started', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', user_id: user.id)
  end

  describe '画面表示' do
    before do
      visit tasks_path
    end

    context 'ログインしていない時の画面表示' do
      it 'ログイン画面が表示される' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'ログイン処理' do
    before do
      visit tasks_path
      fill_in 'ユーザー名', with: login_name
      fill_in 'パスワード', with: 'rakuten'
      click_button 'commit'
    end

    context 'ログイン画面からログインできる' do
      let(:login_name) { 'YoshioRakuten' }

      it '正常ログイン' do
        expect(page).to have_content '最初のタスク'
      end
    end

    context '誤った情報でログインしようとする' do
      let(:login_name) { 'NotYoshioRakuten' }

      it 'ログインできない' do
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end
end
