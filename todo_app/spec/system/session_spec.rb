# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :sytem do
  describe '#new' do
    before {
      create(:user)
      visit login_path
    }

    context 'when fill valid email and vaild passowrd' do
      let!(:user) { create(:user) }
      it 'success redirect to root_path' do
        fill_in :session_email, with: user.email
        fill_in :session_password, with: user.password

        click_button I18n.t('common.action.login')

        expect(current_path).to eq root_path
        expect(page).to have_content(I18n.t('sessions.flash.success.create'))
      end
    end

    context 'when email and passowrd are nil' do
      it 'failure login and render login page' do
        fill_in :session_email, with: nil
        fill_in :session_password, with: nil

        click_button I18n.t('common.action.login')

        expect(current_path).to eq login_path
        expect(page).to have_content(I18n.t('sessions.flash.error.create'))
      end
    end
  end
end
