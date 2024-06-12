require 'rails_helper'

RSpec.describe 'Sessions', type: :system do 
  describe 'login page' do 
    it 'should correctly render components' do 
      visit login_path

      # page title
      expect(page).to have_content(I18n.t('views.titles.login'))
      # username field
      expect(page).to have_field(I18n.t('views.labels.username'))
      # password field
      expect(page).to have_field(I18n.t('views.labels.password'))
      # login button
      expect(page).to have_button(I18n.t('views.buttons.login'))
      # signup text
      expect(page).to have_content(I18n.t('views.texts.to_signup_1'))
      # signup link
      expect(page).to have_link(I18n.t('views.texts.here'))
      # signup text
      expect(page).to have_content(I18n.t('views.texts.to_signup_2'))
    end

    it 'should jump to index page when log in' do 
      username = 'username'
      password = 'password'
      User.create(username: username, password: password)

      visit login_path

      fill_in I18n.t('views.labels.username'), with: username
      fill_in I18n.t('views.labels.password'), with: password
      click_on I18n.t('views.buttons.login')

      expect(current_path).to eq(tasks_path)
    end

    it 'should show error message when fail to log in' do 
      visit login_path

      click_on I18n.t('views.buttons.login')

      expect(page).to have_content('Wrong username or password!')
    end

    it 'should jump to signup page when clicking here link' do 
      visit login_path

      click_on I18n.t('views.texts.here')

      expect(current_path).to eq(signup_path)
    end
  end

  describe 'log out feature' do 
    it 'should return to login page when log out' do 
      username = 'username'
      password = 'password'
      User.create(username: username, password: password)

      visit login_path

      fill_in I18n.t('views.labels.username'), with: username
      fill_in I18n.t('views.labels.password'), with: password
      click_on I18n.t('views.buttons.login')

      expect(current_path).to eq(tasks_path)

      click_on I18n.t('views.buttons.logout')

      expect(current_path).to eq(login_path)
    end
  end
end
