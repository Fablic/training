# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :system do
  describe '#new' do
    let(:user_email) { 'taro.takuten@mail.com' }
    before { visit new_user_path }
    context 'when user with same email not exist' do
      it 'creates a new user' do
        fill_in 'user_name', with: 'Taro Rakuten'
        fill_in 'user_email', with: user_email
        fill_in 'user_password', with: '123'
        fill_in 'user_password_confirmation', with: '123'

        expect { click_button 'Sign Up' }.to change(User, :count).by(1)

        welcome_message = 'Thank you for signing up'
        expect(page).to have_content welcome_message
      end
    end

    context 'when user with same email already exists' do
      before { create(:user, email: user_email) }
      it 'does not create a new user' do
        fill_in 'user_name', with: 'Momo Rakuten'
        fill_in 'user_email', with: user_email
        fill_in 'user_password', with: '321'
        fill_in 'user_password_confirmation', with: '321'

        expect { click_button 'Sign Up' }.to change(User, :count).by(0)

        error_message = 'e-mail has already been taken'
        expect(page).to have_content error_message
      end
    end
  end
end
