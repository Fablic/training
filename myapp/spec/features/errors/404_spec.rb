# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '404' do
  feature '#not_found' do
    scenario 'correctly displays 404' do
      visit '/aqua'

      expect(page).to have_content '404なので僕のせいじゃないっす。'
      expect(page.status_code).to eq 404
    end
  end
end
