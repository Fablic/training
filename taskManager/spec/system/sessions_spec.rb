require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  context 'create new user' do
    let!(:user) { create(:user) }

    it 'can logged in' do
      visit sign_in_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'hoge123'

      click_on I18n.t('sessions.new.sign_in')

      expect(page).to have_content(I18n.t('sessions.create.logged_in'))
    end

    it 'can not logged in' do
      visit sign_in_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'hoge1234'

      click_on I18n.t('sessions.new.sign_in')

      expect(page).to have_content(I18n.t('sessions.create.retry'))
    end
  end
end
