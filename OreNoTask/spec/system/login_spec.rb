# frozen_string_literal: true

require 'rails_helper'
describe 'ログイン機能', type: :system do
  let!(:user) { create(:user, name: 'YoshioRakuten', password: 'rakuten') }
  let!(:task) { create(:task, name: '最初のタスク', status: 'not_started', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', user_id: user.id) }

  describe 'ログイン画面' do
    context 'ログイン画面からログインできる' do
      it '正常ログイン' do
        visit tasks_path
        expect(page).to have_content 'ログイン'

        fill_in 'ユーザー名', with: 'YoshioRakuten'
        fill_in 'パスワード', with: 'rakuten'
        click_button 'commit'

        expect(page).to have_content '最初のタスク'
      end
    end

    context '誤った情報でログインしようとする' do
      it 'ログインできない' do
        visit tasks_path
        expect(page).to have_content 'ログイン'

        fill_in 'ユーザー名', with: 'NotYoshioRakuten'
        fill_in 'パスワード', with: 'rakuten'
        click_button 'commit'

        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end
end
