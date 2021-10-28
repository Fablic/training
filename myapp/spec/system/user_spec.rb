require 'rails_helper'

RSpec.describe UsersController, type: :system do
  let(:user) { create(:user) }

  describe '#signup' do
    before { visit signup_path }
    context 'When the registration is successful.' do
      it 'Register and go to the index page.' do
        signup
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.users.flash.added'))
      end
    end
    context 'When registration fails.' do
      it 'The screen does not transition and an error message is displayed.' do
        signup(name: '', email: '', password: '', password_confirmation: '')
        expect(page).to have_current_path(signup_path)
        expect(page).to have_content(I18n.t('form.error', smtg: 6))
      end
    end
  end

  describe '#edit' do
    before do
      log_in_as user
      visit edit_user_path user
    end
    context 'When the edit is successful.' do
      it 'Register and go to the index page.' do
        fill_in I18n.t('activerecord.attributes.user.name'), with: 'test_name'
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.users.flash.edited'))
      end
    end
    context 'When edit fails.' do
      it 'The screen does not transition and an error message is displayed.' do
        fill_in I18n.t('activerecord.attributes.user.name'), with: ''
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(edit_user_path(user))
        expect(page).to have_content(I18n.t('form.error', smtg: 2))
      end
    end
  end
end
