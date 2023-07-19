# frozen_string_literal: true

require 'rails_helper'

def login_with_normal_user
  visit '/login'
  fill_in 'session[name]', with: 'user_n'
  fill_in 'session[password]', with: '123'
  click_on 'Login'
end

def login_with_admin_user
  visit '/login'
  fill_in 'session[name]', with: 'user_a'
  fill_in 'session[password]', with: '123'
  click_on 'Login'
end

def logout
  visit '/'
  click_on 'Log out'
end

def create_test_users
  create_normal_user
  create_admin_user
end

def create_normal_user
  create(:user, name: 'user_n', password: '123', role: 1)
end

def create_admin_user
  create(:user, name: 'user_a', password: '123', role: 0)
end

RSpec.describe 'Users' do
  describe 'page rendering' do
    before do
      create_test_users
      login_with_admin_user
    end

    let!(:user) { User.last }

    it 'user list page should be shown' do
      visit '/admin/users'
      expect(page).to have_content 'Users'
    end

    it 'users should be listed in the user list page', :aggregate_failures do
      visit '/admin/users'
      expect(page).to have_link 'user_a'
      expect(page).to have_link 'user_n'
    end

    it 'user detail page should be shown' do
      visit "/admin/users/#{user.id}"
      expect(page).to have_content 'User detail'
    end

    it 'user edit page should be shown' do
      visit "/admin/users/#{user.id}/edit"
      expect(page).to have_content 'Edit user'
    end

    it 'user create page should be shown' do
      visit '/admin/users/new'
      expect(page).to have_content 'New user'
    end

    it 'admin should not be be shown to normal users', :aggregate_failures do
      logout
      login_with_normal_user
      visit '/admin/users/'
      expect(page).to have_content '404'
    end
  end

  describe 'user creation' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'user created successfully & show flash message when user created', :aggregate_failures do
      visit '/admin/users'
      click_link('New user')
      fill_in 'user[name]', with: 'a_new_user'
      fill_in 'user[password]', with: '123'
      fill_in 'user[description]', with: 'new user description'
      select('admin', from: 'user[role]')
      click_on 'Create User'
      expect(page).to have_link 'a_new_user'
      expect(page).to have_content 'User was successfully created.'
    end

    it 'user failed to be created due to empty name' do
      visit '/admin/users'
      click_link('New user')
      fill_in 'user[name]', with: ''
      fill_in 'user[password]', with: '123'
      fill_in 'user[description]', with: 'new user description'
      select('admin', from: 'user[role]')
      click_on 'Create User'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'user update' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'user name updated successfully from user lists page', :aggregate_failures do
      visit '/admin/users'
      click_on('Edit', match: :first)
      fill_in 'user[name]', with: 'user_after_edit'
      click_on 'Update User'
      expect(page).to have_content 'user_after_edit'
      expect(page).to have_content 'User was successfully updated.'
    end

    it 'user name updated successfully from user details page', :aggregate_failures do
      visit '/admin/users'
      click_link('user_n')
      click_on('Edit')
      fill_in 'user[name]', with: 'user_after_edit'
      click_on 'Update User'
      expect(page).to have_content 'user_after_edit'
      expect(page).to have_content 'User was successfully updated.'
    end

    it 'user description updated successfully', :aggregate_failures do
      visit '/admin/users'
      click_on('Edit', match: :first)
      fill_in 'user[name]', with: 'user_after_edit'
      fill_in 'user[description]', with: 'description after'
      click_on 'Update User'
      expect(page).to have_content 'description after'
      expect(page).to have_content 'User was successfully updated.'
    end

    it 'user failed to be updated due to empty name' do
      visit '/admin/users'
      click_on('Edit', match: :first)
      fill_in 'user[name]', with: ''
      click_on 'Update User'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'user deletion' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'user deleted successfully & show flash message when user deleted', :aggregate_failures do
      visit '/admin/users'
      click_on 'Delete'
      expect(page).not_to have_content 'user_n'
      expect(page).to have_content 'User was successfully destroyed.'
    end
  end

  describe 'pagination' do
    before do
      create_test_users
      login_with_admin_user
      20.times do |i|
        create(:user, name: "User#{i + 1}", password: '123', role: 'normal', description: 'some texts here')
      end
    end

    it 'show 10 users in the 1st page', :aggregate_failures do
      visit '/admin/users'
      8.times do |i|
        expect(page.body).to have_link "User#{i + 1}"
      end
      12.times do |i|
        expect(page.body).not_to have_link "User#{i + 9}"
      end
    end
  end

  describe 'login/logout' do
    it 'login & access tasks page successfully' do
      create_test_users
      login_with_admin_user
      expect(page.body).to have_content 'Tasks'
    end

    it 'login failed', :aggregate_failures do
      visit '/login'
      fill_in 'session[name]', with: 'wrong_user'
      fill_in 'session[password]', with: 'wrong_password'
      click_on 'Login'
      expect(page.body).to have_content 'Login'
      expect(page.body).to have_content 'Login failed. Please input correct user name & password.'
    end

    it 'cannot access user list page without login', :aggregate_failures do
      visit '/admin/users'
      expect(page.body).to have_content 'Login'
      expect(page.body).to have_content 'Please login first!'
    end

    it 'logout successfully', :aggregate_failures do
      create_test_users
      login_with_admin_user
      expect(page.body).to have_content 'Tasks'
      click_button 'Log out'
      expect(page.body).to have_content 'Login'
    end
  end
end
