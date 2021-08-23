# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET new' do
    it 'returns 200' do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST create' do
    it 'has user id in session' do
      post login_path, params: {
        session: { email: user.email, password: user.password }
      }
      expect(session[:user_id]).to be user.id
    end

    it 'returns 302' do
      post login_path, params: {
        session: { email: user.email, password: user.password }
      }
      expect(response).to have_http_status(302)
    end
  end

  describe 'DELETE destroy' do
    before do
      post login_path, params: {
        session: { email: user.email, password: user.password }
      }
    end

    it 'resets session' do
      delete logout_path
      expect(session[:user_id]).to be nil
    end
    
    it 'returns 302' do
      delete logout_path
      expect(response).to have_http_status(302)
    end
  end
end
