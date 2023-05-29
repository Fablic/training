require 'rails_helper'
include SessionsHelper

RSpec.describe 'Sessions', type: :request do
  describe 'GET /new' do
    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end
end
