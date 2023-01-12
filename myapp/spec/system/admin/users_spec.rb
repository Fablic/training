# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::User', type: :system do
  context 'when admin user logged in' do
    let(:admin_user) { create(:user, :admin) }
    let(:rspec_session) { {user_id: admin_user.id} }

    describe '#index' do
      it 'displays a create user link' do
        create_user_button_text = I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.user'))

        visit admin_users_path

        expect(page).to have_link(create_user_button_text)
      end

      context 'when users already exist' do
        let!(:user_1) { create(:user) }
        let!(:user_2) { create(:user) }

        it 'displays users infos' do
          visit admin_users_path

          expect(page).to have_content user_1.id
          expect(page).to have_content user_1.name
          expect(page).to have_content user_1.email
          expect(page).to have_content user_1.is_admin
          expect(page).to have_content user_2.id
          expect(page).to have_content user_2.name
          expect(page).to have_content user_2.email
          expect(page).to have_content user_2.is_admin
        end

        it 'display user tasks count' do
          create_list(:task, 3, user: user_1)

          visit admin_users_path

          expect(page).to have_content 3
        end
      end
    end

    describe '#new' do
      let(:user_email) { 'taro.rakuten@mail.com' }
      before { visit new_admin_user_path }
      context 'when user with same email not exist' do
        it 'creates a new user' do
          fill_in 'user_name', with: 'Taro Rakuten'
          fill_in 'user_email', with: user_email

          expect { click_button 'Save user' }.to change(User, :count).by(1)

          success_message = 'User successfully created'
          expect(page).to have_content success_message
        end
      end

      context 'when user with same email already exists' do
        before { create(:user, email: user_email) }
        it 'does not create a new user' do
          fill_in 'user_name', with: 'Momo Rakuten'
          fill_in 'user_email', with: user_email

          expect { click_button 'Save user' }.to change(User, :count).by(0)

          error_message = 'E-mail has already been taken'
          expect(page).to have_content error_message
        end
      end
    end

    describe '#edit' do
      let!(:user) { create(:user) }

      before { visit edit_admin_user_path(user) }

      it 'display the details of the user' do
        expect(page).to have_field 'user_name', with: user.name
        expect(page).to have_field 'user_email', with: user.email
      end

      context 'when input necessary user columns' do
        it 'update user successfully' do
          updated_user_name = 'Updated user name'
          updated_user_email = 'new@mail.com'
          page.check('user_is_admin')

          fill_in 'user_name', with: updated_user_name
          fill_in 'user_email', with: updated_user_email

          click_button 'Save user'

          expect(page).to have_content updated_user_name
          expect(page).to have_content updated_user_email
          expect(user.reload.is_admin).to be_truthy
        end
      end

      context 'when mis-input necessary user column' do
        it 'does not update user' do
          updated_user_name = nil

          fill_in 'user_name', with: updated_user_name

          click_button 'Save user'

          error_message = "User Name can't be blank"
          expect(page).to have_content error_message
        end
      end
    end

    describe '#destroy' do
      let!(:user) { create(:user) }

      describe 'when user can be deleted' do
        it 'destroys user successfully' do
          visit admin_users_path

          expect { find(:xpath, "(//a[text()='Delete'])[2]").click }.to change(User, :count).by(-1)
        end

        context 'when user has tasks' do
          before { create_list(:task, 2, user: user) }
          it 'destroys tasks created by user' do
            visit admin_users_path

            expect { find(:xpath, "(//a[text()='Delete'])[2]").click }.to change(Task, :count).by(-2)
          end
        end
      end

      describe 'when user cannot be deleted' do
        it 'does not delete the user' do
          visit admin_users_path

          expect { find(:xpath, "(//a[text()='Delete'])[1]").click }.to change(User, :count).by(0)
          error_message = 'User deletion failed'
          expect(page).to have_content error_message
        end
      end
    end
  end

  context 'when non admin user logged in' do
    let(:user) { create(:user) }
    let(:rspec_session) { {user_id: user.id} }

    it 'redirect user to root_path' do
      visit admin_users_path

      expect(page).to have_content 'Tasks List'
      expect(page).not_to have_content 'Users List'
    end
  end
end
