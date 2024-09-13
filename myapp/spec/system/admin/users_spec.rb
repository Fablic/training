require 'rails_helper'

RSpec.describe Admin::UsersController, type: :system do
  include LoginHelper

  describe '#index' do
    context 'when user is anonymous' do
      before do
        visit admin_users_path
      end

      it 'user should be redirected to login page' do
        expect(current_path).to eq login_path
      end
    end
    context 'when user is normal user' do
      before do
        user_1 = create(:user)
        log_in(user_1)
        visit admin_users_path
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
      end
    end

    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, role: User.roles[:role_moderator])
        log_in(@moderator_1)
        visit admin_users_path
      end

      it 'user should access admin top page' do
        expect(current_path).to eq admin_users_path

        expect(page).to have_field 'ユーザーネーム'
        expect(page).to have_field 'パスワード'
        expect(page).to have_field 'パスワード確認'
        expect(page).to have_select('user[role]', options: ['通常', 'moderator', 'admin'])
        expect(page).to have_button 'Create'
      end

      context 'when there are users' do
        before do
          @user_1 = create(:user, name: 'user1', role: User.roles[:role_moderator])
          @user_2 = create(:user, name: 'user2', role: User.roles[:role_normal])
          @user_3 = create(:user, name: 'user3', role: User.roles[:role_normal])
          visit admin_users_path
        end

        it 'user should see user list' do
          expect(page).to have_content @moderator_1.name
          expect(page).to have_content @user_1.name
          expect(page).to have_content @user_2.name
          expect(page).to have_content @user_3.name
        end
      end
    end
  end

  describe '#create' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, role: User.roles[:role_moderator])
        log_in(@moderator_1)
        visit admin_users_path
      end

      it 'creates new user successfully' do
        new_user_name = 'JohnDoe'
        new_user_password = 'dummyPassword123!?'
        fill_in 'user[name]', with: new_user_name
        fill_in 'user[password]', with: new_user_password
        fill_in 'user[password_confirmation]', with: new_user_password
        select I18n.t(:role_moderator), from: 'user[role]'
        click_on 'btn-submit'

        expect(current_path).to eq admin_users_path
        expect(page).to have_content '作成に成功しました'
        expect(page).to have_content new_user_name
        expect(page).to have_content I18n.t(:role_moderator)
      end

      context 'when user creation is failed' do
        before do
          visit admin_users_path
          @short_user_name = '123'
          fill_in 'user[name]', with: @short_user_name
          fill_in 'user[password]', with: ''
          click_on 'btn-submit'
        end

        it 'error message is shown on the same page' do
          expect(current_path).to eq admin_users_path
          expect(page).to have_content '作成に失敗しました'
          expect(page).to have_content 'Nameは5文字以上で入力してください'
          expect(page).to have_content 'Passwordを入力してください'
          expect(page).to have_field 'user[name]', with: @short_user_name
        end
      end
    end
  end

  describe '#edit' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, name: 'moderator', role: User.roles[:role_moderator])
        log_in(@moderator_1)

        @user_1 = create(:user, name: 'user1')
        visit edit_admin_user_path(@user_1)
      end

      it 'moderator should see user edit form' do
        expect(current_path).to eq edit_admin_user_path(@user_1)

        expect(page).to have_field 'user[name]', disabled: true
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
        expect(page).to have_select('user[role]', options: ['通常', 'moderator', 'admin'], selected: '通常')
        expect(page).to have_button 'Update'
      end
    end

    context 'when user is normal user' do
      before do
        user_1 = create(:user, role: User.roles[:role_normal])
        log_in(user_1)

        user_2 = create(:user)
        visit edit_admin_user_path(user_2)
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#update' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, name: 'moduser', role: User.roles[:role_moderator])
        log_in(@moderator_1)

        @user_1 = create(:user, name: 'user1')
        visit edit_admin_user_path(@user_1)
      end

      it 'admin should update user info successfully' do
        new_user_password = 'dummyPassword123!?'
        fill_in 'user[password]', with: new_user_password
        fill_in 'user[password_confirmation]', with: new_user_password
        select I18n.t(:role_moderator), from: 'user[role]'
        click_on 'btn-submit'

        expect(current_path).to eq edit_admin_user_path(@user_1)
        expect(page).to have_content '更新に成功しました'
        expect(page).to have_select('user[role]', options: ['通常', 'moderator', 'admin'], selected: 'moderator')
      end

      context 'when user update is failed' do
        it 'error message is shown on the same page' do
          new_user_password = 'dummyPassword123!?'
          fill_in 'user[password]', with: new_user_password
          fill_in 'user[password_confirmation]', with: 'RandomPassword123!?'
          select I18n.t(:role_moderator), from: 'user[role]'
          click_on 'btn-submit'

          expect(page).to have_content '更新に失敗しました'
          expect(page).to have_content 'Password confirmationとPasswordの入力が一致しません'
        end
      end
    end
  end

  describe '#destroy' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, id: 1, name: 'moduser', role: User.roles[:role_moderator])
        log_in(@moderator_1)

        @admin_1 = create(:user, id: 2, name: 'admin', role: User.roles[:role_admin])

        @user_1 = create(:user, id: 3, name: 'user1')
        visit admin_users_path
      end

      it 'admin should delete user info successfully' do
        find('form[action="/admin/users/3"]').click_on 'btn-delete'

        expect(current_path).to eq admin_users_path
        expect(page).to have_content '削除に成功しました'
      end

      context 'when trying to delete admin user' do
        it 'admin user cannot be deleted' do
          find('form[action="/admin/users/2"]').click_on 'btn-delete'

          expect(current_path).to eq admin_users_path
          expect(page).to have_content 'adminは削除できません'
        end
      end

      context 'when trying to delete myself' do
        it 'admin user cannot be deleted' do
          find('form[action="/admin/users/1"]').click_on 'btn-delete'

          expect(current_path).to eq admin_users_path
          expect(page).to have_content '自分は削除できません'
        end
      end
    end
  end

end
