# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/auth', type: :request do
  describe 'POST /login' do
    context 'with correct credentials' do
      it 'renders a successful response' do
        user = create(:user, password: 'p@ssword')
        post '/login', params: { email: user.email, password: 'p@ssword' }, as: :json
        expect(response).to be_successful
      end

      it 'returns JWT token' do
        user = create(:user, password: 'p@ssword')
        post '/login', params: { email: user.email, password: 'p@ssword' }, as: :json
        expect(JSON.parse(response.body)).to include('token')
      end

      it 'token payload to contain user_id and role' do
        user = create(:user, password: 'p@ssword')
        post '/login', params: { email: user.email, password: 'p@ssword' }, as: :json
        token = JSON.parse(response.body)['token']
        payload = JWT.decode(token, Rails.application.secrets.jwt_secret_key, true, algorithm: 'HS256').first
        expect(payload['user_id']).to eq(user.id)
        expect(payload['role']).to eq(user.role)
      end
    end

    context 'with incorrect credentials' do
      it 'renders unauthorized' do
        user = create(:user, password: 'p@ssword')
        post '/login', params: { email: user.email, password: 'wrong_password' }, as: :json
        expect(response.status).to eq(401)
      end
    end
  end
end
