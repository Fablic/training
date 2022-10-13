# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  describe 'GET /admin' do
    context 'when admin_user logined' do
      let!(:admin_user) { create(:user, role: 'admin') }
      before do
        post '/login', params: { session: { email: admin_user.email, password: admin_user.password } }
      end

      it 'returns http success' do
        get '/admin'

        expect(response).to have_http_status(:success)
      end
    end

    context 'when ordinary_user logined' do
      let!(:ordinary_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: ordinary_user.email, password: ordinary_user.password } }
      end

      it 'returns http found' do
        get '/admin'

        expect(response).to have_http_status :not_found
        expect(response.body).to include '404なので僕のせいじゃないっす'
        expect(response.body).to include '多分アドレスとか違うっす'
      end
    end
  end
end
