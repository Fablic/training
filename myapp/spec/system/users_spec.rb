require 'rails_helper'

RSpec.describe 'Users', type: :system do 
  describe 'signup page' do 
    it 'should correctly render components' do 
      visit users_signup_path

      expect(page).to have_content('User Signup')
      expect(page).to have_button('Back to login')
      expect(page).to have_field('Username')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')
      expect(page).to have_button('Sign Up')
    end

    context 'when input invalid value' do 
      it 'should show error message for username less than 3 chars' do 
        visit users_signup_path 

        fill_in 'Password', with: '12345'
        fill_in 'Password confirmation', with: '12345'
        # find("input[type='password']").set('12345')
        
        click_on 'Sign Up'
        
        expect(page).to have_content('Username should be between 3 and 20 chars!')
      end
      
      it 'should show error message for username more than 20 chars' do 
        visit users_signup_path 
        
        fill_in 'Username', with: 'a' * 21
        fill_in 'Password', with: '12345'
        fill_in 'Password confirmation', with: '12345'
        
        click_on 'Sign Up'

        expect(page).to have_content('Username should be between 3 and 20 chars!')
      end

      it 'should show error message for empty password' do 
        visit users_signup_path 

        fill_in 'Username', with: 'username'

        click_on 'Sign Up'

        expect(page).to have_content("Password #{I18n.t 'errors.messages.blank'}")
        expect(page).to have_content("Password confirmation #{I18n.t 'errors.messages.confirmation'}")
      end
    end

    it 'should jump to index page when sign up' do 
      visit users_signup_path

      fill_in 'Username', with: 'new_user'
      fill_in 'Password', with: '12345'
      fill_in 'Password confirmation', with: '12345'

      click_on 'Sign Up'

      expect(current_path).to eq(tasks_path)
    end

    it 'should jump back to login page when clicking back button' do 
      visit users_signup_path

      click_on 'Back to login'

      expect(current_path).to eq(login_path)
    end
  end
end
