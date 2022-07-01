# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :system do
  include TasksHelper
  let!(:normal_user) do
    FactoryBot.create(:user)
  end
  let!(:admin_user) do
    FactoryBot.create(:user, email: 'admin@example.com', role: 'admin')
  end

  describe 'ユーザー管理画面への遷移前', type: :system do
    context 'Adminユーザーのとき' do
      example 'ヘッダーにリンクが表示' do
        login(admin_user)
        expect(page).to have_link 'Admin', href: '/admin/users'
      end
    end
    context '一般ユーザーのとき' do
      example 'ヘッダーにリンクが表示されない' do
        login(normal_user)
        expect(page).to have_no_link 'Admin', href: '/admin/users'
      end
      example '直接管理ページにアクセスしてもメインページにリダイレクトされる' do
        login(normal_user)
        visit admin_users_path
        expect(page).to have_content I18n.t('tasks.index.all')
      end
    end
  end
  describe 'ユーザー管理画面に遷移後', type: :system do
    before do
      login(admin_user)
      click_link 'Admin'
    end

    context 'ユーザー一覧画面' do
      example 'ユーザーの一覧が表示されるか' do
        check_user_list(normal_user, page)
        check_user_list(admin_user, page)
        expect(User.count).to eq 2
      end
    end

    context 'ユーザー作成したとき' do
      example '一覧画面にユーザーが一人追加される' do
        expect do
          click_link 'New User', href: '/admin/users/new'
          fill_in 'Name', with: 'newuser'
          fill_in 'Email', with: 'newuser@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Confirmation', with: 'password'
          click_button 'Submit'
          new_user = User.find_by(email: 'newuser@example.com')
          check_user_list(new_user, page)
        end.to change(User, :count).by(1)
      end
    end

    context 'ユーザーのロールを変更したとき' do
      context '通常ユーザーからAdminユーザーに変更したとき' do
        example 'roleがadminになりflashメッセージが表示' do
          select 'admin', from: "user_role_#{normal_user.id}"
          click_button "role_#{normal_user.id}"
          expect(find_by_id("user_#{normal_user.id}")).to have_content 'admin'
          expect(page).to have_content I18n.t('admin.users.update.flash_update')
        end
      end
      context 'Adminユーザーから通常ユーザーに変更し、更新後にadminが1人以上になるとき' do
        example 'roleがnormalになりflashメッセージが表示' do
          select 'normal', from: "user_role_#{normal_user.id}"
          click_button "role_#{normal_user.id}"
          expect(find_by_id("user_#{normal_user.id}")).to have_content 'normal'
          expect(page).to have_content I18n.t('admin.users.update.flash_update')
        end
      end
      context 'Adminユーザーから通常ユーザーに変更し、更新後にadminが0人になるとき' do
        example 'flashメッセージが表示され更新されない' do
          select 'normal', from: "user_role_#{admin_user.id}"
          click_button "role_#{admin_user.id}"
          expect(find_by_id("user_#{admin_user.id}")).to have_content 'admin'
          expect(page).to have_content I18n.t('admin.users.update.flash_req')
        end
      end
    end

    context 'ユーザーの更新' do
      context '正しいデータで更新したとき' do
        example 'ユーザー管理画面へリダイレクトされflashメッセージが表示' do
          click_link "edit-#{normal_user.id}"
          fill_in 'Name', with: 'Name-update'
          click_button 'Submit'
          expect(find_by_id("user_#{normal_user.id}")).to have_content 'Name-update'
          expect(page).to have_content I18n.t('admin.users.update.flash_update')
        end
      end
      context 'PasswordとConfirmationが異なるとき' do
        example 'パスワードは更新されずflashメッセージが表示' do
          click_link "edit-#{normal_user.id}"
          fill_in 'Password', with: 'hoge'
          fill_in 'Confirmation', with: 'fuga'
          click_button 'Submit'
          expect(page).to have_content I18n.t('errors.messages.confirmation', attribute: 'Password')
        end
      end
    end

    context 'ユーザーの削除' do
      context '自分を削除するとき' do
        example '削除されずflashメッセージが表示' do
          click_link "delete-#{admin_user.id}"
          expect(page).to have_content I18n.t('admin.users.destroy.flash_delete_me')
          expect(page).to have_content admin_user.id
        end
      end
      context '他のユーザーを削除するとき' do
        example '削除されflashメッセージが表示' do
          click_link "delete-#{normal_user.id}"
          expect(page).to have_content I18n.t('admin.users.destroy.flash_deleted')
          expect(page).not_to have_content normal_user.id
        end
      end
    end
  end
end
