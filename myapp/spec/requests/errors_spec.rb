# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/errors', type: :request do
  describe '404' do
    it 'renders a successful response' do
      get '/aqua'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe '500' do
    before do
      allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
    end

    it 'renders a successful response' do
      get tasks_path

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
