require 'rails_helper'

RSpec.describe 'Sessions (System)', type: :system do
  context 'create new user' do
    let!(:user) { create(:user) }

    it 'can logged in' do
      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'abc1234'

      click_on 'Login'

      expect(page).to have_content(user.name)
    end

    it 'can not logged in' do
      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'abc'

      click_on 'Login'

      expect(page).to have_text('Something went wrong! Make sure email and password are correct')
    end
  end
end
