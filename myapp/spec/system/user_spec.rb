require 'rails_helper'

RSpec.describe User, type: :system do
  let!(:user) { create(:user, name: 'MM', email: 'hoge@hoge.com', password: 'password') }

  describe '画面表示' do
    before do
      visit new_user_path
    end

    context 'ユーザー新規登録ページにアクセスしたとき' do
      it 'ユーザー新規登録の画面が表示されること' do
        expect(page).to have_current_path new_user_path, ignore_query: true
        expect(page).to have_field 'user[name]'
        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end
  end

  describe 'ユーザー登録' do
    before do
      visit new_user_path
      fill_in 'user[name]', with: 'test子'
      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    context '正しい情報を入力したとき' do
      before do
        click_button '登録'
      end

      it 'ユーザー登録できる' do
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.create', model_name: I18n.t('activerecord.models.user')))
      end
    end

    context 'nameを入力しなかったとき' do
      before do
        fill_in 'user[name]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content '氏名を入力してください'
      end
    end

    context 'emailを入力しなかったとき' do
      before do
        fill_in 'user[email]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'emailに256文字以上入力したとき' do
      before do
        fill_in 'user[email]', with: "#{'a' * 256}" + '@test.com'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスは255文字以内で入力してください'
      end
    end

    context '登録済みのメールアドレスを入力したとき' do
      before do
        fill_in 'user[email]', with: 'hoge@hoge.com'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end

    context 'メールアドレスフォーマット以外を入力したとき' do
      before do
        fill_in 'user[email]', with: '@testtest.com'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'パスワードが空欄のとき' do
      before do
        fill_in 'user[password]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードが7文字で入力したとき' do
      before do
        fill_in 'user[password]', with: 'passwor'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワードは8文字以上で入力してください'
      end
    end

    context 'パスワード、パスワード確認が異なる値で入力されたとき' do
      before do
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
      end
    end
  end
end
