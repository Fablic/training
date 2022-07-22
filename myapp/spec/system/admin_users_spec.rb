# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:user, name: 'test1', email: 'test1@gmail.com', admin: true) }

  before do
    login(user: user)
  end

  describe '#index' do
    before do
      create(:task, name: 'テスト1', description: 'コインランドリーに行く', priority: 'Low', status: 'TODO', user_id: user.id)
      create(:task, name: 'テスト2', description: 'クリーニング屋に行く', priority: 'High', status: 'DONE', user_id: user.id)
      visit admin_users_path
    end

    it 'can display admin/users page', :aggregate_failures do
      expect(page).to have_content 'test1'
      expect(page).to have_content 'test1@gmail.com'
      expect(page).to have_content '2'
      expect(page).to have_content '編集'
      expect(page).to have_content '削除'
    end
  end

  describe '#show' do
    before do
      create(:task, name: 'テスト1', description: 'コインランドリーに行く', priority: 'Low', status: 'TODO', user_id: user.id)
      create(:task, name: 'テスト2', description: 'クリーニング屋に行く', priority: 'High', status: 'DONE', user_id: user.id)
      visit admin_users_path
    end

    it 'can display user info', :aggregate_failures do
      puts current_path
      within '.table' do
        click_on 'test1'
      end
      expect(page).to have_current_path admin_user_path(user.id)
      expect(page).to have_content 'test1'
      expect(page).to have_content 'test1@gmail.com'
      expect(page).to have_content 'テスト1'
      expect(page).to have_content 'テスト2'
    end
  end

  describe '#new' do
    before do
      visit admin_users_path
      click_on '新規作成'
    end

    it 'can go to new page' do
      expect(page).to have_current_path new_admin_user_path
    end
  end

  describe '#edit' do
    before do
      visit admin_users_path
      click_on '編集'
    end

    it 'can go to edit page' do
      expect(page).to have_current_path edit_admin_user_path(user.id)
    end

    it 'can display user info', :aggregate_failures do
      expect(page).to have_field 'Name', with: 'test1'
      expect(page).to have_field 'Email', with: 'test1@gmail.com'
    end
  end

  describe '#create' do
    before do
      visit admin_users_path
      click_on '新規作成'
    end

    context 'when input user info' do
      before do
        fill_in 'Name', with: 'test2'
        fill_in 'Email', with: 'test2@gmail.com'
        fill_in 'Password', with: 'password'
      end

      it 'can create new user', :aggregate_failures do
        click_on '作成'
        expect(page).to have_content 'test1'
        expect(page).to have_content 'test2'
      end
    end
  end

  describe '#update' do
    before do
      visit admin_users_path
    end

    context 'when update user info' do
      before do
        create(:user, id: 2, name: 'test2', email: 'test2@gmail.com')
        visit current_path
        click_on '編集', match: :first
        fill_in 'Name', with: 'おかもと'
        select '管理ユーザ', from: 'Admin'
      end

      it 'can change user info' do
        click_on '更新'
        expect(page).to have_content 'おかもと'
      end
    end

    context 'when update last admin user info' do
      before do
        click_on '編集', match: :first
        select '一般ユーザ', from: 'Admin'
      end

      it 'can not change role' do
        click_on '更新'
        expect(page).to have_content 'Failed'
      end
    end
  end

  describe '#destroy' do
    let(:destroy_user) { create(:user, id: 2, name: 'test2', email: 'test2@gmail.com') }

    before do
      create(:task, name: 'destroy task', description: 'destroy task description', priority: 'Low', status: 'TODO', user_id: destroy_user.id)
      visit admin_users_path
    end

    context 'when push destroy button' do
      before do
        click_on '削除', match: :first
      end

      it 'can destroy user' do
        expect(page).not_to have_content 'test2'
      end

      it 'can destroy task too' do
        change(Task, :count).by(-1)
      end
    end

    context 'when push destroy button that has last admin user' do
      before do
        all('tbody tr td').last.click_link '削除'
      end

      it 'can not destroy last admin user' do
        expect(page).to have_content 'The last admin user cannot be deleted!!'
      end
    end
  end
end
