require 'rails_helper'

RSpec.describe "Errors", type: :request do
  %w[400 404 406 422 500].each do |code|
    describe "GET /#{code}" do
      it "renders the error page for #{code}" do
        get "/#{code}"
        expect(response).to have_http_status(code.to_i)
        
        case code.to_i
        when 400
          expect(response.body).to include(I18n.t 'page.error_page.bad_request')
        when 404
          expect(response.body).to include(I18n.t 'page.error_page.not_found')
        when 406
          expect(response.body).to include(I18n.t 'page.error_page.not_acceptable')
        when 422
          expect(response.body).to include(I18n.t 'page.error_page.unprocessable_entity')
        when 500
          expect(response.body).to include(I18n.t 'page.error_page.internal_server_error')
        end
      end
    end
  end

  describe "GET /test (invalid code)" do
    it "returns 404" do
      get "/test"
      expect(response).to have_http_status(404)
    end
  end
end
