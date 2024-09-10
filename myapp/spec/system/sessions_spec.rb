require 'rails_helper'

RSpec.describe SessionsController, type: :system do
  include LoginHelper

  describe '#new' do
    context 'when user is anonymous' do
      before { visit login_path }

      it 'shows user login form' do
        expect(page).to have_field 'ユーザーネーム'
        expect(page).to have_field 'パスワード'
        expect(page).to have_button 'Login'
      end
    end
    context 'when user is logged-in' do
      before do
        user_1 = create(:user)
        log_in(user_1)
        visit login_path
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
        expect(page).not_to have_button 'Login'
      end
    end
  end

  describe '#create' do
    context 'when user is anonymous' do
      let!(:user_1) { create(:user) }

      before { visit login_path }

      it 'login successfully' do
        fill_in 'session[name]', with: user_1.name
        fill_in 'session[password]', with: user_1.password
        click_on 'btn-login'

        expect(current_path).to eq root_path
      end

      it 'failed to login due to blank name' do
        fill_in 'session[name]', with: ''
        fill_in 'session[password]', with: user_1.password
        click_on 'btn-login'

        expect(page).to have_content 'usernameまたはpasswordが正しくありません'
        expect(current_path).to eq login_path
      end
      it 'failed to login due to blank password' do
        fill_in 'session[name]', with: user_1.name
        fill_in 'session[password]', with: ''
        click_on 'btn-login'

        expect(page).to have_content 'usernameまたはpasswordが正しくありません'
        expect(current_path).to eq login_path
      end
      it 'failed to login due to wrong password' do
        fill_in 'session[name]', with: user_1.name
        fill_in 'session[password]', with: 'someRandomPass'
        click_on 'btn-login'

        expect(page).to have_content 'usernameまたはpasswordが正しくありません'
        expect(current_path).to eq login_path
      end
    end
  end

  describe '#destroy' do
    before do
      user = create(:user)
      log_in(user)
    end

    context 'when user is logged in' do
      it 'logout successfully' do
        visit root_path

        expect(current_path).to eq root_path
        click_on 'Logout'

        expect(current_path).to eq login_path
      end
    end
  end
end
