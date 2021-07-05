# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :system do
  include_context 'set_user'
  let(:admin_user) { create(:user, role: :admin) }

  describe '#index' do
    context 'login_as admin_user' do
      it 'sucess visit admin page' do
        login_as admin_user
        visit admin_root_path

        expect(current_path).to eq admin_root_path
        expect(page).to have_content(User.all.first.email)
      end
    end

    context 'login_as general user' do
      it 'display unauthorized page' do
        login_as user
        visit admin_root_path

        expect(page).to have_content(I18n.t('common.error.unauthorized'))
      end
    end
  end

  describe '#new' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Alphanumeric.alpha(number: 10) }
    before {
      login_as admin_user
      visit new_admin_user_path
    }

    it 'success create user and redirect to admin_root_path' do
      fill_in :user_email, with: email
      fill_in :user_password, with: password
      fill_in :user_password_confirmation, with: password

      expect do
        click_button I18n.t('common.action.create')
      end.to change(User, :count).by(1)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content(email)
      expect(page).to have_content(I18n.t('users.flash.success.create'))
    end
    it 'error occurred and render new' do
      fill_in :user_email, with: nil
      fill_in :user_password, with: nil
      fill_in :user_password_confirmation, with: nil

      expect do
        click_button I18n.t('common.action.create')
      end.to change(User, :count).by(0)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content('メールアドレスを入力してください')
      expect(page).to have_content('パスワードを入力してください')
      expect(page).to have_content(I18n.t('users.flash.error.create'))
    end
  end

  describe '#edit' do
    let(:old_user_info) { User.first }
    let(:new_email) { Faker::Internet.email }
    let(:new_password) { Faker::Alphanumeric.alpha(number: 10) }
    before {
      login_as admin_user
      visit edit_admin_user_path(old_user_info)
    }

    it 'success create user and redirect to admin_root_path' do
      fill_in :user_email, with: new_email
      fill_in :user_password, with: new_password
      fill_in :user_password_confirmation, with: new_password

      expect do
        click_button I18n.t('common.action.update')
      end.to change(User, :count).by(0)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content(new_email)
      expect(page).to have_content(I18n.t('users.flash.success.update'))
      expect(page).not_to have_content(old_user_info.email)
    end
    it 'error occurred and render new' do
      fill_in :user_email, with: nil

      expect do
        click_button I18n.t('common.action.update')
      end.to change(User, :count).by(0)
      expect(current_path).to eq admin_user_path(old_user_info)
      expect(page).to have_content('メールアドレスを入力してください')
      expect(page).to have_content(I18n.t('users.flash.error.update'))
    end
  end

  describe '#destroy' do
    let!(:delete_user) { create(:user, role: :admin) }
    let!(:delete_user_task) { create(:task, user: delete_user) }
    before {
      login_as admin_user
      visit admin_root_path
    }

    context 'when click delete button' do
      it 'sucess destroy and redirect to admin_root_path' do
        expect do
          find("a[href='#{admin_user_path(delete_user)}']").click
        end.to change(User, :count).by(-1)
        .and change(Task, :count).by(-1)

        expect(current_path).to eq admin_users_path
        expect(page).to have_content(I18n.t('users.flash.success.destroy'))
        expect(page).to_not have_content(delete_user.id)
        expect(page).to_not have_content(delete_user.email)
      end
    end

    context 'when want to destory current user' do
      it 'delete button is not displayed' do
        expect(page).to_not have_link("a[href='#{admin_user_path(delete_user)}']")
      end
    end
  end

  describe '#tasks' do
    let!(:new_user) { create(:user) }
    let!(:current_user_task) { create(:task, user: user) }
    let!(:new_user_task) { create(:task, user: new_user) }
    it 'find current user tasks' do
      login_as admin_user
      visit tasks_admin_user_path(user)

      expect(current_path).to eq tasks_admin_user_path(user)
      expect(page).to have_content(current_user_task.title)
      expect(page).to_not have_content(new_user_task.title)
    end
  end
end
