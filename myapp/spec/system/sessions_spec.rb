# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sessions', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task_list) { FactoryBot.create_list(:task, 4, user: user) }

  describe '#new' do
    before { visit login_path }
    context 'when move to root_path with non login status' do
      it 'move to login page, success' do
        expect(current_path).to eq login_path
      end
    end
    context 'when move to root_path with login status' do
      before do
        fill_in 'Name',     with: user.name
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end
      it 'move to root page, success' do
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#create' do
    before { visit login_path }
    context 'when login without name' do
      it 'login failed' do
        fill_in 'Password', with: user.password
        click_button 'Log in'
        expect(page).to have_content 'login failed'
      end
    end
    context 'when login without password' do
      it 'login failed' do
        fill_in 'Name',     with: user.name
        click_button 'Log in'
        expect(page).to have_content 'login failed'
      end
    end
    context 'when login with incorrect password' do
      it 'login failed' do
        fill_in 'Name',     with: user.name
        fill_in 'Password', with: 'incorrect'
        click_button 'Log in'
        expect(page).to have_content 'login failed'
      end
    end
  end

  describe '#destroy' do
    before do
      visit login_path
      fill_in 'Name',     with: user.name
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end

    context 'when click logout, move to login page' do
      it 'move to login page success' do
        click_on 'ログアウト'
        expect(current_path).to eq login_path
      end
    end
  end
end
