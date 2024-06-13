require 'rails_helper'

RSpec.describe 'Users', type: :system do 
  describe 'signup page' do 
    it 'should correctly render components' do 
      visit signup_path

      expect(page).to have_content(I18n.t('views.titles.signup'))
      expect(page).to have_button(I18n.t('views.buttons.back_to_login'))
      expect(page).to have_field(I18n.t('views.labels.username'))
      expect(page).to have_field(I18n.t('views.labels.password'))
      expect(page).to have_field(I18n.t('activerecord.attributes.user.password_confirmation'))
      expect(page).to have_button(I18n.t('views.buttons.signup'))
    end

    context 'when input invalid value' do 
      it 'should show error message for username less than 3 chars' do 
        visit signup_path 

        fill_in I18n.t('views.labels.password'), with: '12345'
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '12345'
        
        click_on I18n.t('views.buttons.signup')
        
        expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.username.too_short'))
      end
      
      it 'should show error message for username more than 20 chars' do 
        visit signup_path 
        
        fill_in I18n.t('views.labels.username'), with: 'a' * 21
        fill_in I18n.t('views.labels.password'), with: '12345'
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '12345'
        
        click_on I18n.t('views.buttons.signup')

        expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.username.too_long'))
      end

      it 'should show error message for empty password' do 
        visit signup_path 

        fill_in I18n.t('views.labels.username'), with: 'username'

        click_on I18n.t('views.buttons.signup')

        expect(page).to have_content(I18n.t('activerecord.errors.messages.blank'))
        expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation'))
      end

      it 'should show error message for duplicated username' do 
        User.create!(username: 'username', password: '12345')

        visit signup_path

        fill_in I18n.t('views.labels.username'), with: 'username'

        click_on I18n.t('views.buttons.signup')

        expect(page).to have_content(I18n.t('activerecord.errors.models.user.attributes.username.taken'))
      end
    end

    it 'should jump to index page when sign up' do 
      visit signup_path

      fill_in I18n.t('views.labels.username'), with: 'new_user'
      fill_in I18n.t('views.labels.password'), with: '12345'
      fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '12345'

      click_on I18n.t('views.buttons.signup')

      expect(current_path).to eq(tasks_path)
    end

    it 'should jump back to login page when clicking back button' do 
      visit signup_path

      click_on I18n.t('views.buttons.back_to_login')

      expect(current_path).to eq(login_path)
    end
  end
end
