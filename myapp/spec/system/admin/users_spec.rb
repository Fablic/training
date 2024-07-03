# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do

  before do
    @admin = User.create(name: 'admin01', password: 'admin01', role: 'admin')
    visit session_path
    fill_in 'name', with: @admin.name
    fill_in 'password', with: @admin.password
    click_button 'commit'
  end

  describe 'list' do
    before do
      User.create(name: 'user01', password: 'user01', role: 'standard')
      User.create(name: 'user02', password: 'user02', role: 'standard')
      visit admin_users_path
    end

    context 'When a user exists' do
      it 'Check the message and the order of users' do
        expect(page).to have_content('Users')
        expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('admin01')
        expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('user01')
        expect(find('tr:nth-child(3) td:nth-child(1)').text).to eq('user02')
      end
    end
  end


  describe 'Screen transition' do
    before do
      visit admin_users_path
    end

    context 'Display the new creation screen' do
      before do
        click_button 'create'
      end
      it 'Check the type of screen' do
        expect(page).to have_content('Create User')
      end
    end

    context 'Display the updating screen' do
      it 'Check the type of screen' do
        click_button 'update-0'
        expect(page).to have_content('Edit User')
      end
    end

    context 'Display the details screen' do
      it 'Check the type of screen' do
        user = User.create(name: 'user01', password: 'user01', role: 'standard')
        visit admin_users_path
        click_link user.name
        expect(page).to have_content('Details')
      end
    end
  end

  describe 'Create a user' do
    it 'standard' do
      visit new_admin_user_path
      fill_in 'user_name', with: 'user01'
      fill_in 'user_password', with: 'user01'
      fill_in 'user_password_confirmation', with: 'user01'
      select 'standard', from: 'user_role'
      click_button 'proceed'

      expect(page).to have_content('Details')
      expect(page).to have_content('user01')
      expect(page).to have_content('standard')
    end

    it 'admin' do
      visit new_admin_user_path
      fill_in 'user_name', with: 'user01'
      fill_in 'user_password', with: 'user01'
      fill_in 'user_password_confirmation', with: 'user01'
      select 'admin', from: 'user_role'
      click_button 'proceed'

      expect(page).to have_content('Details')
      expect(page).to have_content('user01')
      expect(page).to have_content('admin')
    end
  end


  describe 'Update a user' do

    it 'Update is OK' do
      user = User.create(name: 'user01', password: 'user01', role: 'standard')
      visit edit_admin_user_path(user)
      fill_in 'user_password', with: 'user01-mod'
      fill_in 'user_password_confirmation', with: 'user01-mod'
      select 'admin', from: 'user_role'
      click_button 'proceed'

      expect(page).to have_content('Details')
      expect(page).to have_content('admin')
    end

    it 'Update is Ng, because The user_password and user_password_confirmation do not match.' do
      user = User.create(name: 'user01', password: 'user01', role: 'standard')
      visit edit_admin_user_path(user)
      fill_in 'user_password', with: 'user01-mod'
      fill_in 'user_password_confirmation', with: 'user01-mod-1'
      click_button 'proceed'

      expect(page).to have_content('Edit User')
      expect(page).not_to have_content('Details')
    end

    context 'Admin role' do
      it 'Update is Ng, because there is only one admin user, and trying to change the admin role to standard' do
        visit edit_admin_user_path(@admin)
        expect(page).to have_content('Edit User')

        select 'standard', from: 'user_role'
        click_button 'proceed'

        expect(page).to have_content('Users')
        expect(page).to have_content('admin01')
      end
      it 'Update is OK, because there is two admin user, and trying to change the admin role to standard' do
        admin02 = User.create(name: 'admin02', password: 'admin02', role: 'admin')

        visit edit_admin_user_path(admin02)
        expect(page).to have_content('Edit User')

        select 'standard', from: 'user_role'
        click_button 'proceed'

        expect(page).to have_content('Details')
        expect(page).to have_content('admin02')
        expect(page).to have_content('standard')
      end
      it 'Update is OK, because there is two admin user, and trying to change the admin role to standard by myself' do
        User.create(name: 'admin02', password: 'admin02', role: 'admin')

        visit edit_admin_user_path(@admin)
        expect(page).to have_content('Edit User')

        select 'standard', from: 'user_role'
        click_button 'proceed'

        expect(page).to have_content('Search')
      end
    end
  end

  describe 'Delete a user' do
    it 'standard user' do
      user = User.create(name: 'user01', password: 'user01', role: 'standard')
      visit admin_users_path
      expect(page).to have_content('user01')
      click_link 'delete-1'
      expect(page).not_to have_content('user01')
    end
    it 'admin user with two admin users' do
      user = User.create(name: 'admin02', password: 'admin02', role: 'admin')
      visit admin_users_path
      expect(page).to have_content('admin02')
      click_link 'delete-1'
      expect(page).not_to have_content('admin02')
    end
    it 'admin user with one admin users' do
      visit admin_users_path
      expect(page).to have_content('admin01')
      click_link 'delete-0'
      expect(page).to have_content('admin01')
    end
  end
end
