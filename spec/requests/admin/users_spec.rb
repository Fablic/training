require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in create(:admin_user)
  end

  describe 'GET index' do
    it 'returns http success' do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      get admin_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET new' do
    it 'returns http success' do
      get new_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      get edit_admin_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST create' do
    it 'creates a user' do
      expect do
        post admin_users_path, params: { user: attributes_for(:user) }
      end.to change(User, :count).by(1)
    end

    it 'returns 302' do
      post tasks_path, params: { task: attributes_for(:task) }
      expect(response).to have_http_status(302)
    end
  end

  describe 'PUT update' do
    it 'updates a user' do
      put admin_user_path(user), params: { user: attributes_for(:user, name: 'updated user') }
      expect(user.reload.name).to eq 'updated user'
    end

    it 'returns 302' do
      put admin_user_path(user), params: { user: attributes_for(:user, name: 'updated user') }
      expect(response).to have_http_status(302)
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { create(:user) }

    it 'deletes a task' do
      expect do
        delete admin_user_path(user)
      end.to change(User, :count).by(-1)
    end

    it 'return 302' do
      delete admin_user_path(user)
      expect(response).to have_http_status(302)
    end
  end
end
