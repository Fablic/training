require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:remote_chrome)
  end

  describe 'GET /' do
    it 'renders a successful response', js: true do
      visit '/'
      # binding.break
      expect(response).to have_http_status(200)
      expect(page).to have_content 'User was successfully created.'
      # binding.break
    end
  end

end
