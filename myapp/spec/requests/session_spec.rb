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
      @user = create(:user, username: 'testUser', password: 'password')
    end

    it 'returns http success', :aggregate_failures do
      post '/login', params: { username: @user.username, password: @user.password }
      expect(response).to have_http_status(:found)
      if I18n.locale.to_s == "en"
        expect(response).to redirect_to('/?locale=en')
      elsif I18n.locale.to_s == "ja"
        expect(response).to redirect_to('/?locale=ja')
      end
    end
  end

  describe 'DELETE /logout' do
    before do
      @user = create(:user, username: 'testUser', password: 'password')
    end

    it 'returns http success', :aggregate_failures do
      post '/login', params: { username: @user.username, password: @user.password }
      delete '/logout'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/login'
    end
  end  

end
