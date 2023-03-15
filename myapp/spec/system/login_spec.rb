require 'rails_helper'

RSpec.describe 'Login', type: :system do
  before do
    driven_by(:remote_chrome)
  end

  let!(:user) {
    create(:user, name: 'taro',
                  email: 'taro@hoge.hoge',
                  password: 'password')
  }

  describe 'login' do
    context 'valid input' do
      before do
        login(user.email, user.password)
      end

      it 'successfully logged in' do
        expect(page).to have_content user.name
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_content 'タスク 一覧'
        expect(page).to have_content 'ログアウト'
      end
    end

    context 'invalid input' do
      before do
        login(user.email, 'hoge')
      end

      it 'failed to log in' do
        expect(page).to have_content 'ログインに失敗しました。メールアドレスとパスワードの組み合わせが不正です。'
        expect(page).not_to have_content user.name
        expect(page).not_to have_content 'ログアウト'
      end
    end
  end

  describe 'logout' do
    before do
      login(user.email, user.password)
      page.accept_confirm do
        click_link('ログアウト')
      end
    end

    it 'successfully logged out' do
      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_content 'ログイン'
    end
  end
end
