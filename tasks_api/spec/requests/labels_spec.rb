# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  describe 'GET /labels' do
    before { FactoryBot.create_list(:label, 100) }

    it 'should return all labels' do
      get '/labels.json'
      ret = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(ret).to eq Label.all.map(&:value)
    end
  end
end
