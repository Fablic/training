# frozen_string_literal: true

require 'rails_helper'
describe 'ログイン機能', type: :system do
  let(:user) { create(:user, name: 'YoshioRakuten', password: 'rakuten') }

  before do
    create(:task, name: '最初のタスク', status: 'not_started', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', user_id: user.id)
  end

  describe 'ログイン画面' do
    before do
      visit tasks_path
    end

    context 'ログイン画面からログインできる' do
      it '正常ログイン' do
        expect(page).to have_content 'ログイン'

        login_action 'YoshioRakuten'

        expect(page).to have_content '最初のタスク'
      end
    end

    context '誤った情報でログインしようとする' do
      it 'ログインできない' do
        expect(page).to have_content 'ログイン'

        login_action 'NotYoshioRakuten'

        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end

  def login_action(login_name)
    fill_in 'ユーザー名', with: login_name
    fill_in 'パスワード', with: 'rakuten'
    click_button 'commit'
  end
end
