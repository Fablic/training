require 'rails_helper'

def sign_in_admin(user)
  visit sign_in_path
  fill_in 'session[email]', with: user.email
  fill_in 'session[password]', with: 'hoge123'
  click_on I18n.t('sessions.new.sign_in')
end

RSpec.describe 'Users', type: :system do
  describe 'Registration Page' do
    let!(:admin) { create(:user, role: :admin) }
    before do
      sign_in_admin(admin)
    end

    context 'initialized input field' do
      it {
        visit new_user_path
        expect(page).to have_content I18n.t('users.new.title')
        expect(find_field(User.human_attribute_name(:email)).value).to be_empty
        expect(find_field(User.human_attribute_name(:last_name)).value).to be_empty
        expect(find_field(User.human_attribute_name(:first_name)).value).to be_empty
        expect(find_field(User.human_attribute_name(:password)).value).to be_empty
        expect(find_field(User.human_attribute_name(:password_confirmation)).value).to be_empty
      }
    end

    context 'when click on registration button' do
      it {
        visit new_user_path
        fill_in User.human_attribute_name(:email),                  with: 'fuga_hoge@example.com'
        fill_in User.human_attribute_name(:first_name),             with: 'fuga'
        fill_in User.human_attribute_name(:last_name),              with: 'hoge'
        fill_in User.human_attribute_name(:password),               with: 'test123'
        fill_in User.human_attribute_name(:password_confirmation),  with: 'test123'
        expect {
          click_on I18n.t('action.create')
          expect(page).to have_content I18n.t('users.new.title')
        }.to change { User.count }.by (1)
        expect(page).to have_content I18n.t('flash.create.success')
      }
    end

    context 'when click on registration button with already exist email' do
      let!(:user1) { create(:user) }
      it {
          visit new_user_path
          fill_in User.human_attribute_name(:email),                  with: user1.email
          fill_in User.human_attribute_name(:first_name),             with: 'fuga'
          fill_in User.human_attribute_name(:last_name),              with: 'hoge'
          fill_in User.human_attribute_name(:password),               with: 'test123'
          fill_in User.human_attribute_name(:password_confirmation),  with: 'test123'
          expect {
            click_on I18n.t('action.create')
            expect(page).to have_content I18n.t('users.new.title')
          }.to change { User.count }.by (0)
          expect(page).to have_content I18n.t('flash.create.danger')
      }
    end
  end
end
