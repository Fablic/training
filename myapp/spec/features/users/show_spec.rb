# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/admin/user/:id' do
  feature '#show' do
    before(:each) { login(user) }

    given(:user) { create(:user, id: 1, name: 'kumaTaro') }
    before do
      create(:task,
             name: 'aqua',
             end_date: '2022/09/14 17:25',
             priority: 'high',
             status: 'untouched',
             explanation: 'aqua hara',
             user_id: user.id)
      create(:task,
             name: 'kuma',
             end_date: '2022/09/16 19:24',
             priority: 'low',
             status: 'touched',
             explanation: 'kumaJiro',
             user_id: user.id)
    end

    scenario 'correctly shows user' do
      visit admin_user_path(user)

      expect(current_path).to eq '/admin/users/1'
      expect(page).to have_content 'aqua'
      expect(page).to have_content '2022/09/14 17:25'
      expect(page).to have_content '高'
      expect(page).to have_content '未着手'
      expect(page).to have_content 'aqua hara'
      expect(page).to have_content 'kumaTaro'

      expect(page).to have_content 'kuma'
      expect(page).to have_content '2022/09/16 19:24'
      expect(page).to have_content '低'
      expect(page).to have_content '着手中'
      expect(page).to have_content 'kumaJiro'
    end

    scenario 'renders #index' do
      visit admin_user_path(user)
      click_on '一覧に戻る'

      expect(current_path).to eq '/admin/users'
      expect(page).to have_content '管理者画面ッ!!'
      expect(page).to have_content 'ユーザ一覧'
    end
  end
end
