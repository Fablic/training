# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:rspec_session) { { user_id: user.id } }

  describe '詳細ページ' do
    before { visit user_path(user) }
    it '既存のユーザー情報が書かれている' do
      expect(page).to have_content 'Taro'
      expect(page).to have_content user.email
    end
  end

  describe '編集ページ' do
    before {
      visit user_path(user)
      click_button 'ユーザーを編集する'
    }

    it '既存のユーザー情報が書いている' do
      expect(page).to have_field 'ユーザー名', with: 'Taro'
    end

    describe '編集' do
      let(:name) { 'pi' }
      let(:email) { 'pi@raspberry.com' }
      let(:password) { 'raspberry' }
      let(:password_confirmation) { 'raspberry' }
      before {
        fill_in 'ユーザー名', with: name
        fill_in 'メールアドレス', with: email
        fill_in 'パスワード', with: password
        fill_in 'パスワードの再確認', with: password_confirmation
        click_button '投稿'
      }

      context '登録可能な形式' do
        it '成功する' do
          expect(page).to have_content 'ユーザーの更新をしました。'
          expect(page).to have_content 'pi'
          expect(page).to have_content 'pi@raspberry.com'
        end

        it '編集したユーザーのページを開く' do
          expect(current_path).to eq user_path(user)
        end
      end

      context 'メールアドレスを入力しない' do
        let(:email) { '' }
        it 'メールアドレスのvalidationエラーが発生する' do
          expect(page).to have_content 'メールアドレス 空になっています。入力してください。'
          expect(page).to have_content 'メールアドレス メールアドレスの形式が間違っています。'
        end
      end

      context 'パスワードとパスワードの再確認の不一致' do
        let(:password_confirmation) { 'a' }
        it 'パスワードの再確認のvalidationエラーが発生する' do
          expect(page).to have_content 'パスワードの再確認 パスワードもしくは再入力されたパスワードが間違っています。'
        end
      end
    end
  end

  describe 'ユーザーの新規作成' do
    let(:name) { 'pi' }
    let(:email) { 'pi@raspberry.com' }
    let(:password) { 'raspberry' }
    let(:password_confirmation) { 'raspberry' }
    before {
      visit new_user_path
      fill_in 'ユーザー名', with: name
      fill_in 'メールアドレス', with: email
      fill_in 'パスワード', with: password
      fill_in 'パスワードの再確認', with: password_confirmation
      click_button '投稿'
    }

    context '登録可能な形式' do
      it '成功する' do
        expect(page).to have_content 'ユーザーの新規作成をしました。'
      end

      it '作成したユーザーのページを開く' do
        wait = Selenium::WebDriver::Wait.new(timeout: 100)
        wait.until { expect(page).to have_content 'ユーザーの新規作成をしました。' }
        expect(current_path).to eq root_path
      end
    end

    context 'メールアドレスを入力しない' do
      let(:email) { '' }
      it 'メールアドレスのvalidationエラーが発生する' do
        expect(page).to have_content 'メールアドレス 空になっています。入力してください。'
        expect(page).to have_content 'メールアドレス メールアドレスの形式が間違っています。'
      end
    end

    context 'パスワードを入力しない' do
      let(:password) { '' }
      it 'パスワードのvalidationエラーが発生する' do
        expect(page).to have_content 'パスワード 空になっています。入力してください。'
      end
    end

    context 'パスワードとパスワードの再確認の不一致' do
      let(:password_confirmation) { 'a' }
      it 'パスワードの再確認のvalidationエラーが発生する' do
        expect(page).to have_content 'パスワードの再確認 パスワードもしくは再入力されたパスワードが間違っています。'
      end
    end
  end

  describe 'ユーザーの削除' do
    before { visit user_path(user) }
    context '削除ボタンを押す' do
      before {
        page.accept_confirm do
          find('a', text: 'ユーザーを削除する').click
        end
      }
      it { expect(page).to have_content 'ユーザーの削除をしました。' }

      it 'ユーザーの作成ページを開く' do
        expect(current_path).to eq new_user_path
      end
    end
  end
end
