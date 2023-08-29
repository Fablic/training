require 'rails_helper'

RSpec.describe "Maintenances", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/maintenance/show"
      expect(response).to have_http_status(:success)
    end
  end

end
