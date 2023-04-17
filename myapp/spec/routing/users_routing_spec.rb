# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    let!(:user_id) { create(:user).id.to_s }

    it 'routes to #index' do
      expect(get: '/admin').to route_to('users#index')
    end
  end
end
