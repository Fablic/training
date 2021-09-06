# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  context '非ログイン時' do
    it 'taskページに飛ぶとログインページに飛ばされる' do
      visit root_path
      expect(page).to have_content 'ログインしてください。'
      expect(current_path).to eq login_path
    end

    it 'ユーザー作成ページには遷移できる' do
      visit new_user_path
      expect(current_path).to eq new_user_path
    end
  end

  describe 'login' do
    let!(:user) { FactoryBot.create(:user) }
    let(:email) { user.email }
    let(:password) { user.password }

    before {
      visit login_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Log in'
    }

    context '適切な入力' do
      it { expect(page).to have_content 'ログインしました。' }

      it 'navigation barの確認' do
        expect(page).to have_content 'Account'
      end
    end

    context '不適切なメールアドレスの入力' do
      let(:email) { 'dame@dame.com' }
      it { expect(page).to have_content 'emailもしくはパスワードが間違っています。' }
    end

    context '不適切なパスワードの入力' do
      let(:password) { 'dame' }
      it { expect(page).to have_content 'emailもしくはパスワードが間違っています。' }
    end
  end

  describe 'Log out' do
    let!(:user) { FactoryBot.create(:user) }
    let(:rspec_session) { { user_id: user.id } }
    before { visit root_path }

    context 'ログアウトボタンを押す' do
      before {
        click_button 'Account'
        find('a', text: 'Log out').click
      }
      it { expect(page).to have_content 'ログアウトしました。' }
    end
  end
end
