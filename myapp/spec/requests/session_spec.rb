require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    before do
      create(:user, username: 'testUser', password: 'password')
    end

    let (:req_params) { { session: { username: 'testUser', password: 'password' } } }

    context "when locale is en" do
      before do
        I18n.locale = :en
      end

      it 'returns http success and redirects to English tasks page', :aggregate_failures do
        post '/login', params: req_params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to('/tasks?locale=en')
      end
    end

    context "when locale is ja" do
      before do
        I18n.locale = :ja
      end

      it 'returns http success and redirects to Japanese tasks page', :aggregate_failures do
        post '/login?locale=ja', params: req_params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to('/tasks?locale=ja')
      end
    end
  end

  describe 'DELETE /logout' do
    before do
      create(:user, username: 'testUser', password: 'password')
    end

    let (:req_params) { { session: { username: 'testUser', password: 'password' } } }

    it 'returns http success', :aggregate_failures do
      post '/login', params: req_params
      delete '/logout'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/login'
    end
  end  
end
