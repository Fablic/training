require 'rails_helper'

RSpec.describe 'Sessions', type: :system do 
  describe 'login page' do 
    it 'should correctly render components' do 
      visit login_path

      # page title
      expect(page).to have_content('Log in')
      # username field
      expect(page).to have_field('Username')
      # password field
      expect(page).to have_field('Password')
      # login button
      expect(page).to have_button('Log in')
      # signup text
      expect(page).to have_content('New user? Click')
      # signup link
      expect(page).to have_link('here')
      # signup text
      expect(page).to have_content('to sign up.')
    end

    it 'should jump to index page when log in' do 
      username = 'username'
      password = 'password'
      User.create(username: username, password: password)

      visit login_path

      fill_in 'Username', with: username
      fill_in 'Password', with: password
      click_on 'Log in'

      expect(current_path).to eq(tasks_path)
    end

    it 'should show error message when fail to log in' do 
      visit login_path

      click_on 'Log in'

      expect(page).to have_content('Wrong username or password!')
    end

    it 'should jump to signup page when clicking here link' do 
      visit login_path

      click_on 'here'

      expect(current_path).to eq(signup_path)
    end
  end

  describe 'log out feature' do 
    it 'should return to login page when log out' do 
      username = 'username'
      password = 'password'
      User.create(username: username, password: password)

      visit login_path

      fill_in 'Username', with: username
      fill_in 'Password', with: password
      click_on 'Log in'

      expect(current_path).to eq(tasks_path)

      click_on 'Log out'

      expect(current_path).to eq(login_path)
    end
  end
end
