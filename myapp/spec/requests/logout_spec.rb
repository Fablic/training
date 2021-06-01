require 'rails_helper'

RSpec.describe LogoutController, type: :request do
  let(:user) { create(:user) }

  describe 'DELETE /logout' do
    it 'resets session' do
      login_as user
      expect(request.session[:user_id]).to eq user.id
      delete '/logout'
      expect(request.session).not_to include(:user_id)
    end

    it 'resets session even for a non-authenticated user' do
      delete '/logout'
      expect(request.session).not_to include(:user_id)
    end
  end
end
