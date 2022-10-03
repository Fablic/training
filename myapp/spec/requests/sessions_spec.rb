# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'returns http success' do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user) }

    it 'returns http success' do
      post '/login', params: { session: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /logout' do
    it 'returns http success' do
      get '/logout'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)
    end
  end
end
