# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :sytem do
  describe '#new' do
    before { visit sign_up_path }

    context 'when fill valid email and vaild passowrd' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Alphanumeric.alpha(number: 10) }
      it 'success create user and redirecto to root_path' do
        fill_in :user_email, with: email
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password

        expect do
          click_button I18n.t('common.action.registration')
        end.to change(User, :count).by(1)
        expect(current_path).to eq root_path
        expect(page).to have_content(I18n.t('users.flash.success.create'))
      end
    end

    context 'when email and passowrd are nil' do
      it 'failure create user and render new page' do
        fill_in :user_email, with: nil
        fill_in :user_password, with: nil
        fill_in :user_password_confirmation, with: nil

        expect do
          click_button I18n.t('common.action.registration')
        end.to change(User, :count).by(0)
        expect(current_path).to eq sign_up_path
        expect(page).to have_content('メールアドレスを入力してください')
        expect(page).to have_content('パスワードを入力してください')
        expect(page).to have_content(I18n.t('users.flash.error.create'))
      end
    end
  end
end
