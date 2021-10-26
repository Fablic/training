require 'rails_helper'

RSpec.describe SessionsController, type: :system do
  let!(:user) { create(:user) }

  describe '#login' do
    before { visit login_path }
    context 'When the login is successful.' do
      it 'Go to the index page.' do
        login
        expect(page).to have_current_path(root_path)
      end
    end
    context 'When the login is fails.' do
      it 'Error occurs without transition to index page.' do
        login(email: '', password: '')
        expect(page).to have_current_path(login_path)
        expect(page).to have_content(I18n.t('pages.sessions.flash.login'))
      end
    end
    context 'When you access without logging in.' do
      it 'Go to the login page.' do
        visit root_path
        expect(page).to have_current_path(login_path)
        expect(page).to have_content(I18n.t('pages.sessions.flash.loginerror'))
      end
    end
  end

  describe '#logout' do
    context 'When log out.' do
      it 'Go to the login page.' do
        log_in_as user
        visit root_path
        click_link I18n.t('common.logout')
        expect(page).to have_current_path(login_path)
      end
    end
  end
end
