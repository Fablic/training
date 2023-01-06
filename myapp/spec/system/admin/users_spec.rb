# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::User', type: :system do
  describe '#index' do
    it 'displays a create user link' do
      create_user_button_text = I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.user'))

      visit admin_users_path

      expect(page).to have_link(create_user_button_text)
    end

    context 'when users already exist' do
      let!(:user_1) { create(:user) }
      let!(:user_2) { create(:user) }

      it 'displays tasks infos' do
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

    it 'display the details of the task' do
      expect(page).to have_field 'user_name', with: user.name
      expect(page).to have_field 'user_email', with: user.email
    end

    context 'when input necessary user columns' do
      it 'update task successfully' do
        updated_user_name = 'Updated task'
        updated_user_email = 'new@mail.com'

        fill_in 'user_name', with: updated_user_name
        fill_in 'user_email', with: updated_user_email

        click_button 'Save user'

        expect(page).to have_content updated_user_name
        expect(page).to have_content updated_user_email
      end
    end

    context 'when mis-input necessary task column' do
      it 'does not update task' do
        updated_user_name = nil

        fill_in 'user_name', with: updated_user_name

        click_button 'Save user'

        error_message = "User Name can't be blank"
        expect(page).to have_content error_message
      end
    end
  end

  describe '#destroy' do
    before { create(:user) }
    it 'destroys user successfully' do
      visit admin_users_path

      expect { click_link 'Delete' }.to change(User, :count).by(-1)
    end
  end
end
