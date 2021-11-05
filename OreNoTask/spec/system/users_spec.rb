# frozen_string_literal: true

require 'rails_helper'
describe 'ユーザー管理機能', type: :system do
  before do
    create(:task, name: 'taro_task1', user_id: user_taro.id)
    create(:task, name: 'taro_task2', user_id: user_taro.id)
    create(:task, name: 'hanako no task', user_id: user_hanako.id)
  end

  let(:rspec_session) { { user_id: user_taro.id } }

  let_it_be(:user_taro) { create(:user, name: 'TaroRakuten', password: 'rakuten', privilege: :admin) }
  let_it_be(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten', privilege: :user) }

  describe 'ユーザー一覧' do
    before do
      visit admin_users_path
    end

    context 'デフォルト表示' do
      it '一覧のデフォルト表示が期待通り' do
        expect(page).to have_content 'TaroRakuten(2)'
        expect(page).to have_content 'HanakoRakuten(1)'
      end
    end

    context 'ページング機能' do
      context 'ページングが動作しているか' do
        it 'ページングリンクが正しく動いている' do
          create_list(:user, 10)

          visit admin_users_path
          click_link '2'
          expect(find('li:nth-child(1)')).to have_content 'test_user_8(0)'

          click_link '1'
          expect(find('li:nth-child(1)')).to have_content 'HanakoRakuten(1)'

          click_link 'Next'
          expect(find('li:nth-child(1)')).to have_content 'test_user_8(0)'

          click_link 'Previous'
          expect(find('li:nth-child(1)')).to have_content 'HanakoRakuten(1)'
        end
      end
    end
  end

  describe 'ユーザー詳細' do
    context '特定ユーザーの詳細画面に遷移し、内容を確認する' do
      before do
        visit admin_users_path
      end

      it '表示される詳細画面の情報が期待通り' do
        click_link 'TaroRakuten(2)'
        expect(page).to have_content 'TaroRakuten'
        expect(find('li:nth-child(1)')).to have_content 'taro_task2'
        expect(find('li:nth-child(2)')).to have_content 'taro_task1'
      end

      it '他のユーザーのタスクが表示されていない' do
        click_link 'TaroRakuten(2)'
        expect(page).not_to have_content 'hanako no task'
      end

      it '対象ユーザーを切り替えても正しくタスクが表示される' do
        click_link 'HanakoRakuten(1)'
        expect(page).to have_content 'HanakoRakuten'
        expect(find('li:nth-child(1)')).to have_content 'hanako no task'
      end
    end
  end

  describe 'ユーザー新規作成' do
    context '新規作成画面でタスクを作成する' do
      it '期待通りの新規ユーザーが作成され、既存データに影響がない' do
        visit new_admin_user_path
        fill_in 'ユーザー名', with: 'ShintaroRakuten'
        fill_in 'パスワード', with: 'rakutenrakuten'

        click_button 'commit'

        # 作成されたユーザーが表示されている
        expect(find('li:nth-child(2)')).to have_content 'ShintaroRakuten(0)'

        # 既存のデータに影響がない
        expect(find('li:nth-child(1)')).to have_content 'HanakoRakuten(1)'
        expect(find('li:nth-child(3)')).to have_content 'TaroRakuten(2)'

        # 詳細画面で作成したタスクの内容を確認
        click_link 'ShintaroRakuten(0)'
        expect(page).to have_content 'ShintaroRakuten'

        # 作成したユーザーでログインできる
        click_button 'ログアウト'
        page.driver.browser.switch_to.alert.accept
        fill_in 'ユーザー名', with: 'ShintaroRakuten'
        fill_in 'パスワード', with: 'rakutenrakuten'
        click_button 'commit'
        expect(page).to have_content 'タスク一覧'
      end
    end
  end

  describe 'ユーザー編集' do
    before do
      visit admin_users_path
    end

    context 'ユーザーを編集する' do
      it '期待通りにユーザーが編集され、既存データに影響がない' do
        find('li:nth-child(1)').click_link('編集')
        fill_in 'パスワード', with: 'EditRakuten'

        click_button 'commit'

        # 編集されたユーザーが表示されている
        expect(find('li:nth-child(1)')).to have_content 'HanakoRakuten(1)'

        # 既存のデータに影響がない
        expect(find('li:nth-child(2)')).to have_content 'TaroRakuten(2)'

        # 編集したユーザーでログインできる
        click_button 'ログアウト'
        page.driver.browser.switch_to.alert.accept
        fill_in 'ユーザー名', with: 'HanakoRakuten'
        fill_in 'パスワード', with: 'EditRakuten'
        click_button 'commit'
        expect(page).to have_content 'タスク一覧'
      end
    end

    context '更新時はパスワード入力なしに保存可能' do
      it 'パスワード未入力でも既存データに影響しない' do
        find('li:nth-child(1)').click_link('編集')
        fill_in 'パスワード', with: ''

        click_button 'commit'

        # 編集したユーザーでログインできる
        click_button 'ログアウト'
        page.driver.browser.switch_to.alert.accept
        fill_in 'ユーザー名', with: 'HanakoRakuten'
        fill_in 'パスワード', with: 'rakuten'
        click_button 'commit'
        expect(page).to have_content 'タスク一覧'
      end
    end

    context '更新時のパスワード桁数チェック' do
      it '更新時にもパスワードの桁数チェックが有効' do
        find('li:nth-child(1)').click_link('編集')
        fill_in 'パスワード', with: 'a' * 21

        click_button 'commit'

        expect(page).to have_content 'パスワードは20文字以内で入力してください'
      end
    end
  end

  describe 'ユーザーの削除' do
    context 'ユーザーを削除する' do
      it '期待通りにユーザーが削除され、既存データに影響がない' do
        visit admin_users_path
        find('li:nth-child(1)').click_button('×')
        page.driver.browser.switch_to.alert.accept

        # 削除されたユーザーが表示されてない
        expect(page).not_to have_content 'HanakoRakuten(1)'

        # 既存のデータに影響がない
        expect(find('li:nth-child(1)')).to have_content 'TaroRakuten(2)'

        # 削除したユーザーでログインできない
        click_button 'ログアウト'
        page.driver.browser.switch_to.alert.accept
        fill_in 'ユーザー名', with: 'HanakoRakuten'
        fill_in 'パスワード', with: 'rakuten'
        click_button 'commit'
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end
end
