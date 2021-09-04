# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Users', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:rspec_session) { { user_id: user.id } }

  describe '一覧ページ' do
    # Task一覧画面を開く
    let!(:new_user) { FactoryBot.create(:user, name: 'Hanako', email: 'test@email.com') }
    before {
      create_list(:new_task, 25, user_id: new_user.id)
      visit admin_users_path
    }

    context '初期表示' do
      it '一覧表示されているかの確認' do
        # 画面を検証する
        expect(page).to have_content 'Taro'
        expect(page).to have_content 'Hanako'

        # タスク数の表示
        expect(page).to have_content '25'
      end
    end

    describe '検索' do
      context '名前で検索' do
        before {
          fill_in 'keyword', with: 'Taro'
          click_button '検索'
        }
        it 'Taroが表示される' do
          expect(page).to have_selector '#user-0', text: 'Taro'
          expect(page).to have_no_text 'Hanako'
        end
      end

      context 'メールアドレスで検索' do
        before {
          fill_in 'keyword', with: 'test@email.com'
          click_button '検索'
        }
        it 'test@email.comが表示される' do
          expect(page).to have_selector '#user-0', text: 'test@email.com'
          expect(page).to have_no_text 'Taro'
        end
      end
    end
  end

  describe '詳細ページ' do
    before { visit admin_user_path(user) }
    it '既存のユーザー情報が書かれている' do
      expect(page).to have_content 'Taro'
      expect(page).to have_content user.email
    end
  end

  describe '編集ページ' do
    before {
      visit admin_user_path(user)
      click_button 'ユーザーを編集する'
    }

    it '既存のユーザー情報が書いている' do
      expect(page).to have_field 'ユーザー名', with: 'Taro'
    end

    describe '編集' do
      let(:name) { 'pi' }
      let(:email) { 'pi@raspberry.com' }
      before {
        fill_in 'ユーザー名', with: name
        fill_in 'メールアドレス', with: email
        click_button '投稿'
      }

      context '登録可能な形式' do
        it '成功する' do
          expect(page).to have_content 'ユーザーの更新をしました。'
          expect(page).to have_content 'pi'
          expect(page).to have_content 'pi@raspberry.com'
        end

        it '編集したユーザーのページを開く' do
          expect(current_path).to eq admin_user_path(user)
        end
      end

      context 'メールアドレスを入力しない' do
        let(:email) { '' }
        it 'メールアドレスのvalidationエラーが発生する' do
          expect(page).to have_content 'メールアドレス 空になっています。入力してください。'
          expect(page).to have_content 'メールアドレス メールアドレスの形式が間違っています。'
        end
      end
    end
  end

  describe 'ユーザーの削除' do
    let!(:new_user) { FactoryBot.create(:user) }
    before { visit admin_user_path(new_user) }
    context '削除ボタンを押す' do
      before {
        page.accept_confirm do
          find('a', text: 'ユーザーを削除する').click
        end
      }
      it { expect(page).to have_content 'ユーザーの削除をしました。' }

      it 'ユーザーの作成ページを開く' do
        expect(current_path).to eq admin_users_path
      end
    end
  end
end
