require 'rails_helper'

RSpec.describe 'Logins', type: :system do
  let!(:user) { create(:user, username: 'User1', password: 'password1') }

  describe 'Login process' do
    context 'when visiting the login page' do
      before do
        visit login_path
      end

      it 'displays the login form' do
        expect(page).to have_selector('h2', text: I18n.t('views.common.login'))
        expect(page).to have_field(I18n.t('helpers.label.login.username'))
        expect(page).to have_field(I18n.t('helpers.label.login.password'))
        expect(page).to have_button(I18n.t('views.common.login'))
      end
    end

    context 'when logging in with valid credentials' do
      before do
        visit login_path
        fill_in I18n.t('helpers.label.login.username'), with: 'User1'
        fill_in I18n.t('helpers.label.login.password'), with: 'password1'
        click_button I18n.t('views.common.login')
      end

      it 'redirects to the tasks page with a welcome message' do
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content(I18n.t('views.common.welcome', username: 'User1'))
      end
    end

    context 'when logging in with invalid credentials' do
      before do
        visit login_path
        fill_in I18n.t('helpers.label.login.username'), with: 'User1'
        fill_in I18n.t('helpers.label.login.password'), with: 'wrongpassword'
        click_button I18n.t('views.common.login')
      end

      it 're-renders the login page with an error message' do
        expect(page).to have_current_path(login_path)
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('views.common.login')))
      end
    end

    context 'when not logged in' do
      it 'ログインしていない場合は、タスク管理のページに遷移できない' do
        visit tasks_path
        expect(page).to have_current_path(login_path)
        expect(page).to have_content(I18n.t('views.common.login'))
      end
    end
  end

  describe 'Logout process' do
    before do
      visit login_path
      fill_in I18n.t('helpers.label.login.username'), with: 'User1'
      fill_in I18n.t('helpers.label.login.password'), with: 'password1'
      click_button I18n.t('views.common.login')
    end

    context 'when logging out' do
      before do
        click_button I18n.t('views.common.logout')
      end

      it 'redirects to the login page with a logout message' do
        expect(page).to have_current_path(login_path)
        expect(page).to have_content(I18n.t('views.common.login'))
      end
    end
  end
end
