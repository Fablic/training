require 'rails_helper'

RSpec.describe "Errors", type: :request do
  # Test valid error codes that match the whitelist in your ErrorsController.
  %w[400 404 406 422 500].each do |code|
    describe "GET /#{code}" do
      it "renders the error page for #{code}" do
        get "/#{code}"
        expect(response).to have_http_status(code.to_i)
        
        # Optionally, check for specific text in the rendered error page.
        case code.to_i
        when 400
          expect(response.body).to include("Bad Request")
        when 404
          expect(response.body).to include("Not Found")
        when 406
          expect(response.body).to include("Not Acceptable")
        when 422
          expect(response.body).to include("Unprocessable Entity")
        when 500
          expect(response.body).to include("Internal Server Error")
        end
      end
    end
  end

  # Test for an invalid code; should default to 500:
  describe "GET /test (invalid code)" do
    it "returns 404" do
      get "/test"
      expect(response).to have_http_status(404)
    end
  end
end
