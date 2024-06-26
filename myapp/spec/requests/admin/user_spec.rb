# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:admin) { User.create!(email: 'admin@example.com', password: 'password', admin: true, name: 'Admin') }
  let!(:other_admin) { User.create!(email: 'other_admin@example.com', password: 'password', admin: true, name: 'Admin2') }
  let!(:user) { User.create!(email: 'user@example.com', password: 'password', admin: false, name: 'User') }

  before do
    # Manually sign in by setting the session
    post login_path, params: { session: { email: admin.email, password: admin.password } }
  end

  describe 'DELETE /admin/users/:id' do
    context 'when trying to delete the last admin' do
      before do
        other_admin.update(admin: false)
      end

      it 'does not allow deleting the last admin' do
        expect do
          delete admin_user_path(admin)
        end.not_to change(User, :count)

        expect(response).to redirect_to(admin_users_path)
        follow_redirect!
        expect(response.body).to include('最後の管理者は削除できません。')
      end
    end

    context 'when deleting a non-admin user' do
      it 'allows deleting the user' do
        expect do
          delete admin_user_path(user)
        end.to change(User, :count).by(-1)

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'when deleting a non-last admin user' do
      it 'allows deleting the admin' do
        expect do
          delete admin_user_path(other_admin)
        end.to change(User, :count).by(-1)

        expect(response).to redirect_to(admin_users_path)
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
    context 'when trying to change the last admin to a non-admin' do
      before do
        other_admin.update(admin: false)
      end

      it 'does not allow changing the last admin to a non-admin' do
        patch admin_user_path(admin), params: { user: { admin: false } }

        expect(response).to redirect_to(admin_users_path)
        follow_redirect!
        expect(response.body).to include('最後の管理者は削除できません。')
        admin.reload
        expect(admin.admin).to be true
      end
    end

    context 'when changing a non-admin user to an admin' do
      it 'allows changing the user to an admin' do
        patch admin_user_path(user), params: { user: { admin: true } }

        expect(response).to redirect_to(admin_users_path)
        user.reload
        expect(user.admin).to be true
      end
    end

    context 'when changing a non-last admin user to a non-admin' do
      it 'allows changing the admin to a non-admin' do
        patch admin_user_path(other_admin), params: { user: { admin: false } }

        expect(response).to redirect_to(admin_users_path)
        other_admin.reload
        expect(other_admin.admin).to be false
      end
    end
  end
end

