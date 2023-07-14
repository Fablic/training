# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'GET /login' do
    it 'returns http success' do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    before do
      create(:user, name: 'testUser', password: 'password')
    end

    let (:req_params) { { session: { name: 'testUser', password: 'password' } } }

    it 'returns http success', :aggregate_failures do
      post '/login', params: req_params
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/?locale=en'
    end
  end

  describe 'DELETE /logout' do
    before do
      create(:user, name: 'testUser', password: 'password')
    end

    let (:req_params) { { session: { name: 'testUser', password: 'password' } } }

    it 'returns http success', :aggregate_failures do
      post '/login', params: req_params
      delete '/logout'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/login'
    end
  end
end
