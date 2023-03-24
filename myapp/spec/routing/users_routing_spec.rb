# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    let!(:user_id) { create(:user).id.to_s }

    it 'routes to #index' do
      expect(get: '/admin').to route_to('users#index')
    end

    it 'routes to #index' do
      expect(get: '/admin/users').to route_to('users#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/users/new').to route_to('users#new')
    end

    it 'routes to #show' do
      expect(get: "/admin/users/#{user_id}").to route_to('users#show', id: user_id)
    end

    it 'routes to #edit' do
      expect(get: "/admin/users/#{user_id}/edit").to route_to('users#edit', id: user_id)
    end

    it 'routes to #create' do
      expect(post: '/admin/users').to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: "/admin/users/#{user_id}").to route_to('users#update', id: user_id)
    end

    it 'routes to #destroy' do
      expect(delete: "/admin/users/#{user_id}").to route_to('users#destroy', id: user_id)
    end
  end
end
