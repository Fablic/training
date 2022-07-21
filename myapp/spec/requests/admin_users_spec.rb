# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :request do
  let(:user) { create(:user, name: 'test1', email: 'test1@gmail.com', admin: true) }

  describe 'GET /admin/users' do
    it 'returns http success' do
      sing_in user
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end
end
