require 'rails_helper'

RSpec.describe LoginController, type: :system do
  let(:user) { create(:user, name: 'foo', password: 'secret') }

  describe 'Login page' do
    it 'lets a user login with correct name and password' do
      name = user.name
      password = user.password

      visit '/login'

      fill_in 'Name', with: name
      fill_in 'Password', with: password
      click_button 'Login'

      expect(page).to have_current_path('/en')
    end

    it 'denies login because of incorrect name' do
      password = user.password

      visit '/login'

      fill_in 'Name', with: 'incorrect_username'
      fill_in 'Password', with: password
      click_button 'Login'

      expect(page).to have_current_path('/login')
      expect(page).to have_text('Incorrect name or password')
    end

    it 'denies login because of incorrect password' do
      name = user.name

      visit '/login'

      fill_in 'Name', with: name
      fill_in 'Password', with: 'incorrect_password'
      click_button 'Login'

      expect(page).to have_current_path('/login')
      expect(page).to have_text('Incorrect name or password')
    end
  end
end
