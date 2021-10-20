# frozen_string_literal: true

require 'rails_helper'
describe 'ログイン機能', type: :system do

  before(:all) do
  	@user = create(:user, name: 'TaroRakuten', password: 'rakuten' )
    create(:task, name: '最初のタスク', description: '説明文', status: 'not_started', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', created_at: '2021/07/01 09:00:04', user_id: @user.id)
  end

  describe 'ログイン画面' do
  	context 'ログイン画面からログインできる' do
      it '正常ログイン' do
        visit tasks_path
        expect(page).to have_content 'ログイン'

        fill_in 'ユーザー名', with: 'TaroRakuten'
        fill_in 'パスワード', with: 'rakuten'
        click_button 'commit'

        expect(page).to have_content '最初のタスク'
      end
  	end
  end
end