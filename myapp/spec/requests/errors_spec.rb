# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/errors', type: :request do
  describe '404' do
    it 'renders a successful response' do
      get '/aqua'

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include '404なので僕のせいじゃないっす'
      expect(response.body).to include '多分アドレスとか違うっす'
    end
  end

  describe '500' do
    before do
      allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
    end

    it 'renders a successful response' do
      get tasks_path

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include '500っす。僕が原因っす'
      expect(response.body).to include 'ホントすんません'
    end
  end
end
