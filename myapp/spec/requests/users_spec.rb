require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get "/users/signup"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /signin" do
    it "returns http success" do
      get "/users/signin"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /signout" do
    it "returns http success" do
      get "/users/signout"
      expect(response).to have_http_status(:success)
    end
  end

end
