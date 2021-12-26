# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :system do
  describe 'Set Maintainance Mode' do
    before {
      Maintenance.start
    }

    after {
      Maintenance.stop
    }

    example 'Maintenance Page is shown' do
      visit root_path
      expect(page).to have_http_status :service_unavailable
    end
  end
end
