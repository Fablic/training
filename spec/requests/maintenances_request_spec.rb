require 'rails_helper'

RSpec.describe "Maintenances", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/maintenances/index"
      expect(response).to have_http_status(:success)
    end
  end

end
