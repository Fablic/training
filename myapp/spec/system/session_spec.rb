# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe '#create' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:params) {
      {
        session: {
          email: user.email,
          password: user.password,
        },
      }
    }

    before {
      visit login_path()
    }

    context 'with valid email and password combination' do
      example 'redirect to root path' do
        fill_in 'session[email]', with: params[:session][:email]
        fill_in 'session[password]', with: params[:session][:password]
        find('[name=commit]').click

        expect(page).to have_current_path root_path
      end
    end

    context 'with invalid email' do
      example 'validation error message is shown.' do
        fill_in 'session[email]', with: 'invalid@mail.address'
        fill_in 'session[password]', with: params[:session][:password]
        find('[name=commit]').click

        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
      end
    end

    context 'with invalid password' do
      example 'validation error message is shown.' do
        fill_in 'session[email]', with: params[:session][:email]
        fill_in 'session[password]', with: 'invalide password'
        find('[name=commit]').click

        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
      end
    end
  end

  describe '#destroy' do
    example 'redirect to login_path' do
      visit logout_path
      expect(page).to have_current_path login_path
    end
  end
end
