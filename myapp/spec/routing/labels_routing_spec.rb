# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelsController, type: :routing do
  describe 'routing' do
    let!(:label_id) { create(:label).id.to_s }

    it 'routes to #index' do
      expect(get: '/labels').to route_to('labels#index')
    end

    it 'routes to #new' do
      expect(get: '/labels/new').to route_to('labels#new')
    end

    it 'routes to #edit' do
      expect(get: "/labels/#{label_id}/edit").to route_to('labels#edit', id: label_id)
    end

    it 'routes to #create' do
      expect(post: '/labels').to route_to('labels#create')
    end

    it 'routes to #update via PUT' do
      expect(put: "/labels/#{label_id}").to route_to('labels#update', id: label_id)
    end

    it 'routes to #destroy' do
      expect(delete: "/labels/#{label_id}").to route_to('labels#destroy', id: label_id)
    end
  end
end
