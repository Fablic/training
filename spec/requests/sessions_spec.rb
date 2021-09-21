require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  describe 'not login' do
    it 'should redirect to login page' do
      visit root_path
      expect(page).to have_content 'Log in'
    end
  end

  describe 'not login' do
    let(:user) { create(:user) }
    context 'valid email password' do
      before do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'Log in'
      end
      it 'login success' do
        expect(current_path).to eq root_path
        expect(page).to have_content 'Login successful'
      end
    end

    context 'invalid email password' do
      before do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: ''
        click_button 'Log in'
      end
      it 'login fail' do
        expect(page).to have_content 'Invalid email/password combination'
      end
    end
  end
end
