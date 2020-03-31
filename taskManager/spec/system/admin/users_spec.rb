require 'rails_helper'

RSpec.describe "Users", type: :system do

  let!(:user) {create(:user, role: User.roles[:admin]) }

  before do
    driven_by(:rack_test)
    sign_in_with(user)
  end

  context 'when open user index page' do
    before do
      create_list(:task1, 10, user_id: user.id)
    end

    it do
      visit admin_users_path

      expect(page).to have_content format('%s %s', user.last_name, user.first_name)
      expect(page).to have_content 10
      expect(page).to have_link I18n.t('action.detail'), href: admin_user_path(user.id)
      expect(page).to have_link I18n.t('action.update'), href: edit_admin_user_path(user.id)
      expect(page).to have_link I18n.t('action.remove'), href: admin_user_path(user.id)
    end
  end

  context 'when open user detail page' do
    it do
      visit admin_user_path(user.id)

      expect(page).to have_content user.last_name
      expect(page).to have_content user.first_name
      expect(page).to have_content user.email
      expect(page).to have_link I18n.t('action.update'), href: edit_admin_user_path(user.id)
    end
  end

  context 'when tries to edit user information' do
    it  do
      visit edit_admin_user_path(user.id)
      fill_in User.human_attribute_name(:last_name), with: '楽天'
      fill_in User.human_attribute_name(:first_name), with: '太郎'
      fill_in User.human_attribute_name(:email), with: 'taro.rakuten@example.com'
      click_on I18n.t('action.update')

      expect(page).to have_content I18n.t('flash.update.success')
    end
  end

  context 'when user deletes the other user on user detail page' do
    let!(:user1) { create(:user, role: User.roles[:admin]) }
    it do
      visit admin_user_path(user1.id)
      click_on I18n.t('action.remove')
      expect(page).to have_content I18n.t('flash.remove.success')
    end
  end

  context 'When there is validation error' do
    it do
      visit edit_admin_user_path(user.id)
      fill_in User.human_attribute_name(:last_name), with: 'テ' * 21
      fill_in User.human_attribute_name(:email), with: 'test.taro@example.com'
      click_on I18n.t('action.update')

      expect(page).to have_content '更新に失敗しました。'
      expect(page).to have_content '名前（姓）は20文字以内で入力してください'
    end

    it 'Fail to update a user because empty name' do
      visit edit_admin_user_path(user.id)
      fill_in User.human_attribute_name(:last_name), with: ''
      fill_in User.human_attribute_name(:email), with: 'test.taro@example.com'
      click_on I18n.t('action.update')

      expect(page).to have_content '更新に失敗しました。'
      expect(page).to have_content '名前（姓）を入力してください'
    end

    it 'Fail to update a user because of the format of email' do
      visit edit_admin_user_path(user.id)
      fill_in User.human_attribute_name(:last_name), with: 'テスト'
      fill_in User.human_attribute_name(:email), with: 'test'
      click_on I18n.t('action.update')

      expect(page).to have_content '更新に失敗しました。'
      expect(page).to have_content 'メールアドレスは不正な値です'
    end

    it 'Fail to update a user because empty email' do
      visit edit_admin_user_path(user.id)
      fill_in User.human_attribute_name(:last_name), with: 'テスト'
      fill_in User.human_attribute_name(:email), with: ''
      click_on I18n.t('action.update')

      expect(page).to have_content '更新に失敗しました。'
      expect(page).to have_content 'メールアドレスを入力してください'
    end
  end
end
