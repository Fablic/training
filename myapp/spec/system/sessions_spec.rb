# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sessions', type: :system do
  let!(:user) { create(:user) }
  let!(:task_list) { create_list(:task, 5, user: user) }

  describe '#new' do
    before { visit login_path }

    context 'when click the login botton' do
      it 'move to root page' do
        fill_in 'session_login_id', with: user.login_id
        fill_in 'session_password', with: user.password
        click_button I18n.t('login.new.login')

        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end

  describe '#create' do
    before { visit login_path }

    context 'when click login botton without enter id' do
      it 'login failed' do
        fill_in 'session_password', with: user.password
        click_button I18n.t('login.new.login')
        expect(page).to have_content I18n.t('sessions.flash.invalid_login')
      end
    end

    context 'when click login botton without enter password' do
      it 'login failed' do
        fill_in 'session_login_id', with: user.name
        click_button I18n.t('login.new.login')
        expect(page).to have_content I18n.t('sessions.flash.invalid_login')
      end
    end

    context 'when click login botton with enter wrong id' do
      it 'login failed' do
        fill_in 'session_login_id', with: 'wrong id'
        fill_in 'session_password', with: user.password
        click_button I18n.t('login.new.login')
        expect(page).to have_content I18n.t('sessions.flash.invalid_login')
      end
    end
  end

  describe '#destroy' do
    before do
      visit login_path
      fill_in 'session_login_id', with: user.name
      fill_in 'session_password', with: user.password
      click_button I18n.t('login.new.login')
    end

    context 'when click the logout botton' do
      it 'move to login page' do
        click_on I18n.t('login.new.logout')
        expect(page).to have_current_path login_path, ignore_query: true
      end
    end
  end
end
